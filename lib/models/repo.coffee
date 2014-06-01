_ = require 'underscore'
{Model} = require 'backbone'
{File} = require 'pathwatcher'

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
    @current_branch = new CurrentBranch()
    git.on "reload", @reload

  reload: =>
    git.setPath()
    @file_list.reload()
    @current_branch.reload()
    @branch_list.reload()
    @commit_list.reload(@current_branch)

  selection: ->
    @active_list.selection()

  leaf: ->
    @active_list.leaf()

  commitMessagePath: ->
    atom.project.getRepo().getWorkingDirectory() + "/.git/COMMIT_EDITMSG_ATOMATIGIT"

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

    file = new File @commitMessagePath()
    file.write('')

    editor = atom.workspace.open(@commitMessagePath(), {changeFocus: true})
    editor.then (result) =>
      @writeCommitMessage(result)

  writeCommitMessage: (editor) =>
    snippet = """$0
      # Please enter the commit message for your changes. Lines starting
      # with '#' will be ignored, and an empty message aborts the commit.
      # On branch #{@current_branch.localName()}\n
    """

    switch_state = (type) ->
      switch type
        when "M" then "modified:   "
        when "R" then "renamed:    "
        when "D" then "deleted:    "
        when "A" then "new file:   "
        else ""

    filesStaged = @file_list.staged()
    snippet += "#\n# Changes to be committed:\n" if filesStaged.length >= 1
    snippet += "#\t #{switch_state(file.diffType())} #{file.path()}\n" for file in filesStaged

    filesUnstaged = @file_list.unstaged()
    snippet += "#\n# Changes not staged for commit:\n" if filesUnstaged.length >= 1
    snippet += "#\t #{switch_state(file.diffType())} #{file.path()}\n" for file in filesUnstaged

    filesUntracked = @file_list.untracked()
    snippet += "#\n# Untracked files:\n" if filesUntracked.length >= 1
    snippet += "#\t #{file.path()}\n" for file in filesUntracked

    editor.setText('')
    editor.setGrammar atom.syntax.grammarForScopeName('text.git-commit')
    Snippets = atom.packages.activePackages.snippets?.mainModule
    Snippets?.insert(snippet, editor)

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
