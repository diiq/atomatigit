_             = require 'lodash'
{View}        = require 'atom-space-pen-views'
DiffChunkView = require './diff-chunk-view'

# Public: Visual representation of a diff object.
class DiffView extends View
  @content: (diff) ->
    @div class: 'diff'

  # Public: Constructor.
  initialize: (@model) ->
    _.each @model?.chunks(), (chunk) => @append new DiffChunkView(chunk)

module.exports = DiffView
