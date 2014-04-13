{View} = require 'atom'
DiffLineView = require './diff-line-view'

module.exports =
class DiffChunkView extends View
  @content: () ->
    @div class: "diff-chunk", click: "clicked"

  initialize: (@model) ->
    @model.on "change:selected", @showSelection

    for line in @model.lines
      @append new DiffLineView line

  beforeRemove: ->
    @model.off "change:selected", @showSelection

  clicked: ->
    @model.selfSelect()

  showSelection: =>
    @removeClass("selected")
    @addClass("selected") if @model.selectedP()
