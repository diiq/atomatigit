{View} = require 'atom'
DiffView = require './diff-view'

module.exports =
class FileView extends View
  @content: (file) ->
    @div class: "file", click: "clicked", =>
      @div class: "filename", "#{file.filename()}"
      @div class: "diff", outlet: "diff_dom"

  initialize: (file) ->
    @model = file
    @model.on "change:selected", @select
    @model.on "change:diff", @show_diff

  beforeRemove: ->
    @model.off "change:selected", @select
    @model.off "change:diff", @show_diff

  clicked: ->
    @model.self_select()

  select: =>
    @removeClass("selected")
    @addClass("selected") if @model.selected()

  show_diff: =>
    if !@model.diff()
      console.log "here"
      @diff_dom.empty()
    else
      console.log "no bu here"
      @diff_dom.html new DiffView @model.diff()
