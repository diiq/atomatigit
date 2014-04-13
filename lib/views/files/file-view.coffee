{View} = require 'atom'
DiffView = require '../diffs/diff-view'

module.exports =
class FileView extends View
  @content: (file) ->
    @div class: "file", click: "clicked", =>
      @div class: "filename", "#{file.path()}"

  initialize: (file) ->
    @model = file
    @model.on "change:selected", @showSelection
    @model.on "change:diff", @showDiff
    @showSelection()

  beforeRemove: ->
    @model.off "change:selected", @showSelection
    @model.off "change:diff", @showDiff

  clicked: ->
    @model.selfSelect()

  showSelection: =>
    @removeClass("selected")
    @addClass("selected") if @model.selectedP()

  showDiff: =>
    @find(".diff").remove()
    if @model.showDiffP()
      @append new DiffView @model.diff()
