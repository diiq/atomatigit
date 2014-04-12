{Model} = require 'backbone'
{git} = require '../git'
FileList = require './file-list'
BranchList = require './branch-list'
CommitList = require './commit-list'
Branch = require './branch'

ErrorModel = require '../error-model'
{spawn} = require 'child_process'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @files = new FileList []
    #@branch_list = new BranchList []
    #@commit_list = new CommitList []

    #@current_branch = new Branch
    #@branch_list.on "repo:reload", => @refresh()
    git.on "change", => @refresh()
    #@commit_list.on "repo:reload", => @refresh()

  refresh: ->
    git.status (files) =>
      @files.populate files

    #@branch_list.reload()
    #@commit_list.reload(@current_branch)

    #@refresh_current_branch()

  # refresh_current_branch: ->
  #   git.branch (head) =>
  #     @current_branch.set head
  #
  #   git.git "log @{u}..", (output) =>
  #     @current_branch.set unpushed: (output != "")

  fetch: ->
    error_model.increment_task_counter()
    git.remoteFetch "origin", =>
      error_model.decrement_task_counter()

  # checkout_branch: ->
  #   @branch_list.checkout_branch

  stash: ->
    git.git "stash"

  stash_pop: ->
    git.git "stash pop"

  selection: ->
    @files.selection()

  initiate_commit: ->
    error_model.increment_task_counter()
    git.git "commit"
    atom.workspaceView.trigger(atom.config.get("atomatigit.pre_commit_hook"))

  complete_commit: ->
    atom.workspaceView.trigger("core:save")
    atom.workspaceView.trigger("core:close")
    spawn "/Users/diiq/utils/atom_commit_editor_complete.sh",
          ["done"],
          stdio: 'pipe',
          env: process.env
    error_model.decrement_task_counter()
    @refresh()

  initiate_create_branch: ->
    @trigger "need_input",
      query: "Branch name"
      callback: (name) =>
        git.create_branch name, =>
          git.git "checkout #{name}"

  push: (remote) ->
    error_model.increment_task_counter()
    remote ?= "origin #{@current_branch.name()}"
    git.remote_push remote, =>
      error_model.decrement_task_counter()

  initiate_git_command: ->
    @trigger "need_input",
      query: "Git command"
      callback: (command) =>
        @git.git command, (result) =>
          ErrorModel.setMessage result
