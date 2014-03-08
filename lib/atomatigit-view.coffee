{View} = require 'atom'
FileListView = require './file-list-view'
gift = require 'gift'

module.exports =
class AtomatigitView extends View
  @content: ->
    @div class: 'atomatigit', =>
      @subview "file_list_view", new FileListView

  initialize: (serializeState, path) ->
    @git = gift path
    atom.workspaceView.command "atomatigit:toggle", => @toggle()

  refresh: ->
    @git.status (_, repo_status) =>
      debugger
      @file_list_view.refresh repo_status.files

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "AtomatigitView was toggled!"
    if @hasParent()
      @detach()
    else
      @refresh()
      atom.workspaceView.appendToRight(this)
