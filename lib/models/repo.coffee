{Model} = require 'backbone'
{spawn} = require 'child_process'

{git} = require '../git'
{FileList} = require './files'
{Branch, BranchList} = require './branches'
{CommitList} = require './commits'


module.exports =
class Repo extends Model
  initialize: (opts) ->
    @files = new FileList []
    @branch_list = new BranchList []
    @active_list = @branch_list
    @commit_list = new CommitList []

    @current_branch = new Branch
    git.on "change", => @refresh()

  refresh: ->
    git.status (files) =>
      @files.populate files

    @branch_list.reload()
    @commit_list.reload(@current_branch)

    @refreshCurrentBranch()

  refreshCurrentBranch: ->
    git.branch (head) =>
      @current_branch.set head

    git.gitNoChange "log @{u}..", (output) =>
      @current_branch.set unpushed: (output != "")

  fetch: ->
    git.incrementTaskCounter()
    git.remoteFetch "origin", =>
      git.decrementTaskCounter()

  checkoutBranch: ->
    @branch_list.checkout_branch

  stash: ->
    git.git "stash"

  stashPop: ->
    git.git "stash pop"

  selection: ->
    @files.selection()

  initiateCommit: ->
    git.incrementTaskCounter()
    git.git "commit"
    atom.workspaceView.trigger(atom.config.get("atomatigit.pre_commit_hook"))

  completeCommit: ->
    atom.workspaceView.trigger("core:save")
    atom.workspaceView.trigger("core:close")
    spawn "/Users/diiq/utils/atom_commit_editor_complete.sh",
          ["done"],
          stdio: 'pipe',
          env: process.env
    git.decrementTaskCounter()
    @refresh()

  initiateCreateBranch: ->
    @trigger "need_input",
      query: "Branch name"
      callback: (name) =>
        git.createBranch name, =>
          git.git "checkout #{name}"

  initiateGitCommand: ->
    @trigger "need_input",
      query: "Git command"
      callback: (command) => git.git command
