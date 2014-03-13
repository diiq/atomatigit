{Model} = require 'backbone'
FileList = require './file-list'
BranchList = require './branch-list'
Branch = require './branch'
gift = require 'gift'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @git = gift(@get "path")
    @file_list = new FileList []
    @branch_list = new BranchList []
    @current_branch = new Branch {repo: @git}

  refresh: ->
    @git.status (e, repo_status) =>
      console.log e if e
      @file_list.refresh repo_status.files

    @git.branches (e, heads) =>
      console.log e if e
      @branch_list.refresh heads

    @refresh_current_branch()

  refresh_current_branch: ->
    @git.branch (e, head) =>
      console.log e if e
      @current_branch.set head

    @git.git "log @{u}..", "", "", (e, output) =>
      console.log e if e
      @current_branch.set unpushed: (output != "")

  fetch: ->
    @git.remote_fetch "", => @refresh

  checkout_branch: ->
    @branch_list.checkout_branch => @refresh()

  stash: ->
    @git.git "stash", @error_callback

  stash_pop: ->
    @git.git "stash pop", @error_callback

  stage: ->
    @git.add @current_file().filename(), @error_callback

  unstage: ->
    @git.git "reset HEAD #{@current_file().filename()}", @error_callback

  kill: ->
    file = @current_file()
    if file.unstaged()
      @git.git "checkout #{file.filename()}", @error_callback
    else if file.untracked()
      @git.add file.filename(), =>
        @git.git "rm -f #{file.filename()}", @error_callback
    else if file.staged()
      @git.git "reset HEAD #{file.filename()}", =>
        @git.git "checkout #{file.filename()}", @error_callback

  open: ->
    filename = @current_file().filename()
    atom.workspaceView.open(filename)

  current_file: ->
    @file_list.selection()

  toggle_file_diff: ->
    file = @current_file()
    if file.diff()
      file.set_diff ""

    else
      if file.unstaged()
        @git.diff "", "", file.filename(), (e, diffs) =>
          if not e
            file.set_diff diffs[0].diff
      else if file.staged()
        @git.diff "--staged", "", file.filename(), (e, diffs) =>
          if not e
            file.set_diff diffs[0].diff
      else


  initiate_commit: ->
    @trigger "need_input", (message) =>
      @git.commit message, @error_callback

  initiate_create_branch: ->
    @trigger "need_input", (name) =>
      @git.create_branch name, =>
        @git.git "checkout #{name}", @error_callback

  push: (remote) ->
    remote ?= "origin #{@current_branch.name()}"
    @git.remote_push remote, @error_callback

  initiate_git_command: ->
    @trigger "need_input", (command) =>
      @git.git command, @error_callback

  error_callback: (e, f, c )=>
    console.log e, f, c if e
    @refresh()
