_            = require 'lodash'
{View}       = require 'atom-space-pen-views'
DiffLineView = require './diff-line-view'

# Public: Visual representation of a {DiffChunk}.
class DiffChunkView extends View
  @content: ->
    @div class: 'diff-chunk', click: 'clicked'

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    _.each @model.lines, (line) => @append new DiffLineView(line)

  # Public: 'detached' hook.
  detached: =>
    @model.off 'change:selected', @showSelection

  # Public: 'clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Public: Show selection.
  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = DiffChunkView
