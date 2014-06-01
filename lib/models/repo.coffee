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
    git.statusFull @writeCommitMessage

  writeCommitMessage: (files) =>
    editor = atom.workspace.getActiveEditor()
    editor.setGrammar atom.syntax.grammarForScopeName('text.git-commit')

    snippet = """$0
      # Please enter the commit message for your changes. Lines starting
      # with '#' will be ignored, and an empty message aborts the commit.
      # On branch #{@current_branch.localName()}
    """

    # Little helper
    switch_state = (type) ->
      switch type
        when "M" then "modified:   "
        when "R" then "renamed:    "
        when "D" then "deleted:    "
        when "A" then "new file:   "
        else ""

    filesStaged = {}
    filesNotStaged = {}
    filesNotTracked = {}
    stateStaged = stateNotStaged = stateUntracked = false
    for own file, fileData of files
      stateStaged = true if fileData.staged
      stateNotStaged = true if not fileData.staged and fileData.tracked
      stateUntracked = true if not fileData.tracked

      filesStaged[file] = fileData if fileData.staged
      filesNotStaged[file] = fileData if not fileData.staged and fileData.tracked
      filesNotTracked[file] = fileData if not fileData.tracked

    for own file, fileData of filesStaged
      gitStatusType = fileData.type
      if gitStatusType?.length > 1
        stateNotStaged = true

        fileObjClone = _.clone(fileData)
        fileObjClone['type'] = gitStatusType.charAt(1)
        fileData.type = fileData.type?.charAt(0)

        # Rare case type 'RM', file has been renamed and modified
        file = file.match(/(.*) -> (.*)/)?[2] if gitStatusType is 'RM'
        filesNotStaged[file] = fileObjClone

    if stateStaged
      snippet += "\n# Changes to be committed:\n"
      for own file, fileData of filesStaged
        snippet += "#\t #{switch_state(fileData.type)} #{file}\n"

    if stateNotStaged
      snippet += "#\n# Changes not staged for commit:\n"
      for own file, fileData of filesNotStaged
        snippet += "#\t #{switch_state(fileData.type)} #{file}\n"

    if stateUntracked
      snippet += "#\n# Untracked files:\n"
      for own file, fileData of filesNotTracked
        snippet += "#\t #{file}\n" unless fileData.tracked

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
