{View} = require 'atom'
DiffChunkView = require './diff-chunk-view'

module.exports =
class DiffView extends View
  @content: (diff) ->
    @div class: "diff"

  initialize: (diff) ->
    @model = diff
    for chunk in @model.chunks()
      @append new DiffChunkView chunk
