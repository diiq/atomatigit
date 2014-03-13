{View} = require 'atom'

module.exports =
class DiffLineView extends View
  @content: (line) ->
    @div class: "diff-line", click: "clicked", line.diff()

  initialize: (file) ->
    @model = file
    if @model.addition
      @addClass "addition"

    if @model.subtraction
      @addClass "subtraction"

    @model.on "change:selected", @select

  beforeRemove: ->
    @model.off "change:selected", @select

  clicked: ->
    #@model.self_select()

  select: =>
    @removeClass("selected")
    @addClass("selected") if @model.selected()
