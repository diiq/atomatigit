{Model} = require 'backbone'
{git} = require '../git'
FileList = require './file-list'
BranchList = require './branch-list'
# CommitList = require './commit-list'
Branch = require './branch'

ErrorModel = require '../error-model'
{spawn} = require 'child_process'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @files = new FileList []
    @branch_list = new BranchList []
    @active_list = @branch_list
    #@commit_list = new CommitList []

    @current_branch = new Branch
    git.on "change", => @refresh()

  refresh: ->
    git.status (files) =>
      @files.populate files

    @branch_list.reload()
    #@commit_list.reload(@current_branch)

    @refreshCurrentBranch()

  refreshCurrentBranch: ->
    git.branch (head) =>
      @current_branch.set head
  #
  #   git.git "log @{u}..", (output) =>
  #     @current_branch.set unpushed: (output != "")

  fetch: ->
    ErrorModel.increment_task_counter()
    git.remoteFetch "origin", =>
      ErrorModel.decrement_task_counter()

  checkoutBranch: ->
    @branch_list.checkout_branch

  stash: ->
    git.git "stash"

  stashPop: ->
    git.git "stash pop"

  selection: ->
    @files.selection()

  initiateCommit: ->
    ErrorModel.increment_task_counter()
    git.git "commit"
    atom.workspaceView.trigger(atom.config.get("atomatigit.pre_commit_hook"))

  completeCommit: ->
    atom.workspaceView.trigger("core:save")
    atom.workspaceView.trigger("core:close")
    spawn "/Users/diiq/utils/atom_commit_editor_complete.sh",
          ["done"],
          stdio: 'pipe',
          env: process.env
    ErrorModel.decrement_task_counter()
    @refresh()

  initiateCreateBranch: ->
    @trigger "need_input",
      query: "Branch name"
      callback: (name) =>
        git.createBranch name, =>
          git.git "checkout #{name}"

  push: (remote) ->
    ErrorModel.increment_task_counter()
    remote ?= "origin #{@current_branch.name()}"
    git.remote_push remote, =>
      ErrorModel.decrement_task_counter()

  initiateGitCommand: ->
    @trigger "need_input",
      query: "Git command"
      callback: (command) =>
        @git.git command, (result) =>
          ErrorModel.setMessage result
