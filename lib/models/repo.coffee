{Model} = require 'backbone'
FileList = require './file-list'
Branch = require './branch'
gift = require 'gift'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @git = gift(@get "path")
    @file_list = new FileList []
    @current_branch = new Branch {}

  refresh: ->
    @git.status (e, repo_status) =>
      console.log e if e
      @file_list.refresh repo_status.files

    @git.branch (e, head) =>
      console.log e if e
      @current_branch.refresh head

    @git.git "log @{u}..", "", "", (e, v) =>
      console.log e if e
      @current_branch.set unpushed: (v != "")

  stage: ->
    @git.add @current_file().filename(), (errors) =>
      console.log errors if errors
      @refresh()

  unstage: ->
    @git.git "reset HEAD #{@current_file().filename()}", (errors) =>
      console.log errors if errors
      @refresh()

  kill: ->
    @git.git "checkout #{@current_file().filename()}", (errors) =>
      console.log errors if errors
      @refresh()

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
      @git.diff "", "", file.filename(), (e, diffs) =>
        if not e
          file.set_diff diffs[0].diff

  initiate_commit: ->
    @trigger "need_input", (message) => @finish_commit(message)

  finish_commit: (message) ->
    @git.commit message, (errors) =>
      console.log errors if errors
      @refresh()

  push: (remote) ->
    remote ?= "origin"
    @git.remote_push remote, (errors) =>
      console.log errors if errors
      @refresh()
