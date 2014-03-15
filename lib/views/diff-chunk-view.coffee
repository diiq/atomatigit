{View} = require 'atom'
DiffLineView = require './diff-line-view'

module.exports =
class DiffChunkView extends View
  @content: (diff_chunk) ->
    @div class: "diff-chunk", =>
      @div outlet: "list_dom"

  initialize: (diff_chunk) ->
    @model = diff_chunk
    @model.on "refresh", @repaint
    @repaint()

  beforeRemove: ->
    @model.off "refresh", @repaint

  empty_list: ->
    @list_dom.empty()

  repaint: =>
    @empty_list()

    for line in @model.lines()
      @list_dom.append new DiffLineView line
