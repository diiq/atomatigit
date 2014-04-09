{View} = require 'atom'
DiffLineView = require './diff-line-view'

module.exports =
class DiffChunkView extends View
  @content: (diff_chunk) ->
    @div class: "diff-chunk", click: "clicked", =>
      @div outlet: "list_dom"

  initialize: (diff_chunk) ->
    @model = diff_chunk
    @model.on "refresh", @repaint
    @model.on "change:selected", @select
    @repaint()

  beforeRemove: ->
    @model.off "refresh", @repaint
    @model.off "change:selected", @select

  empty_list: ->
    @list_dom.empty()

  clicked: ->
    @model.self_select()

  select: =>
    @removeClass("selected")
    @addClass("selected") if @model.selected()

  repaint: =>
    @empty_list()

    for line in @model.lines()
      @list_dom.append new DiffLineView line
