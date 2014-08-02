_       = require 'lodash'
fs      = require 'fs'
path    = require 'path'
{Model} = require 'backbone'

git                         = require '../git'
{FileList}                  = require './files'
{CurrentBranch, BranchList} = require './branches'
{CommitList}                = require './commits'

# Public: Offers access to core functionality regarding the git repository.
class Repo extends Model
  # Public: Constructor
  initialize: ->
    @fileList      = new FileList []
    @branchList    = new BranchList []
    @commitList    = new CommitList []
    @currentBranch = new CurrentBranch(@headRefsCount() > 0)

    @branchList.on 'update', => @commitList.reload()

  # Public: Forces a reload on the repository.
  reload: =>
    @fileList.reload()
    if @headRefsCount() > 0
      @currentBranch.reload()
      @branchList.reload()
      @commitList.reload()

  # Public: Returns the active selection.
  #
  # Returns the active selection as {Object}.
  selection: ->
    @activeList.selection()

  leaf: ->
    @activeList.leaf()

  # Internal: The commit message file path.
  #
  # Returns the commit message file path as {String}.
  commitMessagePath: ->
    path.join(
      atom.project.getRepo()?.getWorkingDirectory(),
      '/.git/COMMIT_EDITMSG_ATOMATIGIT'
    )

  headRefsCount: ->
    atom.project.getRepo()?.getReferences()?.heads?.length ? 0

  fetch: ->
    git.cmd 'fetch'

  checkoutBranch: ->
    @branchList.checkoutBranch

  stash: ->
    git.cmd 'stash'
    .catch (error) -> new ErrorView(error)

  stashPop: ->
    git.cmd 'stash pop'
    .catch (error) -> new ErrorView(error)

  # Internal: Initiate a new commit.
  initiateCommit: ->
    if atom.config.get('atomatigit.PRE_COMMIT_HOOK') isnt ''
      atom.workspaceView.trigger(atom.config.get('atomatigit.PRE_COMMIT_HOOK'))

    fs.writeFileSync(@commitMessagePath(), '')

    editor = atom.workspace.open(@commitMessagePath(), {changeFocus: true})
    editor.then (result) =>
      @writeCommitMessage(result)

  # Internal: Writes the commit message template to the message file.
  #
  # editor - The editor the file is open in as {Object}.
  writeCommitMessage: (editor) =>
    commitMessage = '\n' + """
      # Please enter the commit message for your changes. Lines starting
      # with '#' will be ignored, and an empty message aborts the commit.
      # On branch #{@currentBranch.localName()}\n
    """

    filesStaged = @fileList.staged()
    filesUnstaged = @fileList.unstaged()
    filesUntracked = @fileList.untracked()

    commitMessage += '#\n# Changes to be committed:\n' if filesStaged.length >= 1
    commitMessage += file.commitMessage() for file in filesStaged

    commitMessage += '#\n# Changes not staged for commit:\n' if filesUnstaged.length >= 1
    commitMessage += file.commitMessage() for file in filesUnstaged

    commitMessage += '#\n# Untracked files:\n' if filesUntracked.length >= 1
    commitMessage += file.commitMessage() for file in filesUntracked

    editor.setGrammar atom.syntax.grammarForScopeName('text.git-commit')
    editor.setText(commitMessage)
    editor.setCursorBufferPosition [0, 0]

  # Internal: Commit the changes.
  completeCommit: ->
    git.commit @commitMessagePath()
    .catch (error) -> new ErrorView(error)

  # Public: Initiate the creation of a new branch.
  initiateCreateBranch: ->
    @trigger 'needInput',
      query: 'Branch name'
      callback: (name) ->
        git.cmd "checkout -b #{name}"
        .catch (error) -> new ErrorView(error)

  # Public: Initiate a user defined git command.
  initiateGitCommand: ->
    @trigger 'needInput',
      query: 'Git command'
      callback: (command) ->
        git.cmd command
        .then (output) -> console.log output
        .catch (error) -> new ErrorView(error)

  # Public: Push the repository to the remote.
  push: ->
    @currentBranch.push()

module.exports = Repo
