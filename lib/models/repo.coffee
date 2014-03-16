{Model} = require 'backbone'
FileList = require './file-list'
BranchList = require './branch-list'
CommitList = require './commit-list'
Branch = require './branch'
gift = require 'gift'
error_model = require '../error-model'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @git = gift(@get "path")
    @file_list = new FileList [], repo: @git
    @branch_list = new BranchList [], repo: @git
    @commit_list = new CommitList [], repo: @git

    @current_branch = new Branch {repo: @git}

    @branch_list.on "repo:reload", => @refresh()
    @file_list.on "repo:reload", => @refresh()
    @commit_list.on "repo:reload", => @refresh()

  refresh: ->
    @git.status (e, repo_status) =>
      error_model.set_message "#{e}" if e
      @file_list.refresh repo_status.files

    @branch_list.reload()
    @commit_list.reload(@current_branch)

    @refresh_current_branch()

  refresh_current_branch: ->
    @git.branch (e, head) =>
      error_model.set_message "#{e}" if e
      @current_branch.set head

    @git.git "log @{u}..", "", "", (e, output) =>
      error_model.set_message "#{e}" if e
      @current_branch.set unpushed: (output != "")

  fetch: ->
    @git.remote_fetch "origin", => @refresh()

  checkout_branch: ->
    @branch_list.checkout_branch => @refresh()

  stash: ->
    @git.git "stash", @error_callback

  stash_pop: ->
    @git.git "stash pop", @error_callback

  selected_file: ->
    @file_list.selection()

  selected_branch: ->
    @branch_list.selection()

  selected_commit: ->
    @commit_list.selection()

  initiate_commit: ->
    @trigger "need_input",
      query: "Commit message"
      callback: (message) =>
        message = '"'+message.replace(/(["\s'$`\\])/g,'\\$1')+'"'
        @git.commit message, @error_callback
      block: true

  initiate_create_branch: ->
    @trigger "need_input",
      query: "Branch name"
      callback: (name) =>
        @git.create_branch name, =>
          @git.git "checkout #{name}", @error_callback

  push: (remote) ->
    remote ?= "origin #{@current_branch.name()}"
    @git.remote_push remote, @error_callback

  initiate_git_command: ->
    @trigger "need_input",
      query: "Git command"
      callback: (command) =>
        @git.git command, "", @output_callback

  output_callback: (e, f) =>
    error_model.set_message "#{f}"
    @refresh()

  error_callback: (e, f) =>
    error_model.set_message "#{f}" if e
    @refresh()
