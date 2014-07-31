_ = require 'underscore'
fs = require 'fs'
path = require 'path'
{Model} = require 'backbone'

{git} = require '../git'
{FileList} = require './files'
{CurrentBranch, BranchList} = require './branches'
{CommitList} = require './commits'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @file_list = new FileList []
    @branch_list = new BranchList []
    @commit_list = new CommitList []
    @current_branch = new CurrentBranch(@headRefsCount() > 0)
    git.on "reload", @reload

  reload: =>
    git.setPath()
    @file_list.reload()
    if @headRefsCount() > 0
      @current_branch.reload()
      @branch_list.reload()
      @commit_list.reload(@current_branch)

  selection: ->
    @active_list.selection()

  leaf: ->
    @active_list.leaf()

  commitMessagePath: ->
    path.join(
      atom.project.getRepo()?.getWorkingDirectory(),
      '/.git/COMMIT_EDITMSG_ATOMATIGIT'
    )

  headRefsCount: ->
    atom.project.getRepo().getReferences().heads.length

  fetch: ->
    git.incrementTaskCounter()
    git.remoteFetch "origin", ->
      git.decrementTaskCounter()

  checkoutBranch: ->
    @branch_list.checkout_branch

  stash: ->
    git.git "stash"

  stashPop: ->
    git.git "stash pop"

  initiateCommit: ->
    git.incrementTaskCounter()
    if atom.config.get("atomatigit.pre_commit_hook") != ""
      atom.workspaceView.trigger(atom.config.get("atomatigit.pre_commit_hook"))

    fs.writeFileSync(@commitMessagePath(), '')

    editor = atom.workspace.open(@commitMessagePath(), {changeFocus: true})
    editor.then (result) =>
      @writeCommitMessage(result)

  writeCommitMessage: (editor) =>
    commitMessage = '\n' + """
      # Please enter the commit message for your changes. Lines starting
      # with '#' will be ignored, and an empty message aborts the commit.
      # On branch #{@current_branch.localName()}\n
    """

    filesStaged = @file_list.staged()
    filesUnstaged = @file_list.unstaged()
    filesUntracked = @file_list.untracked()

    commitMessage += "#\n# Changes to be committed:\n" if filesStaged.length >= 1
    commitMessage += file.commitMessage() for file in filesStaged

    commitMessage += "#\n# Changes not staged for commit:\n" if filesUnstaged.length >= 1
    commitMessage += file.commitMessage() for file in filesUnstaged

    commitMessage += "#\n# Untracked files:\n" if filesUntracked.length >= 1
    commitMessage += file.commitMessage() for file in filesUntracked

    editor.setGrammar atom.syntax.grammarForScopeName('text.git-commit')
    editor.setText(commitMessage)
    editor.setCursorBufferPosition [0, 0]

  completeCommit: ->
    git.git "commit --cleanup=strip --file=\"#{@commitMessagePath()}\""
    git.decrementTaskCounter()

  initiateCreateBranch: ->
    @trigger "need_input",
      query: "Branch name"
      callback: (name) ->
        git.createBranch name, ->
          git.git "checkout #{name}"

  initiateGitCommand: ->
    @trigger "need_input",
      query: "Git command"
      callback: (command) -> git.git command

  push: ->
    @current_branch.push()
