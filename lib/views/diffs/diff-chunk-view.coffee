_            = require 'lodash'
{View}       = require 'atom'
DiffLineView = require './diff-line-view'

# Public: Visual representation of a {DiffChunk}.
class DiffChunkView extends View
  @content: ->
    @div class: 'diff-chunk', click: 'clicked'

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    _.each @model.lines, (line) => @append new DiffLineView(line)

  # Public: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'change:selected', @showSelection

  # Public: 'clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Public: Show selection.
  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = DiffChunkView
