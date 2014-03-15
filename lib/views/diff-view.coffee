{View} = require 'atom'
DiffChunkView = require './diff-chunk-view'

module.exports =
class DiffView extends View
  @content: (diff) ->
    @div class: "diff", =>
      @div outlet: "list_dom", ""

  initialize: (diff) ->
    @model = diff
    @model.on "refresh", @repaint
    @repaint()

  beforeRemove: ->
    @model.off "refresh", @repaint

  empty_list: ->
    @list_dom.empty()

  repaint: =>
    @empty_list()

    for chunk in @model.chunks()
      @list_dom.append new DiffChunkView chunk
