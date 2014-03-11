{View} = require 'atom'

module.exports =
class FileView extends View
  @content: (file) ->
    @div class: "file", click: "clicked", =>
      @div class: "filename", "#{file.filename()}"
      @div class: "diff", outlet: "diff", "#{file.diff()}"

  initialize: (file) ->
    @file = file
    @file.on "change:selected", @select
    @file.on "change:diff", @show_diff

  beforeRemove: ->
    @file.off "change:selected", @select
    @file.off "change:diff", @show_diff

  clicked: ->
    @file.self_select()

  select: =>
    @removeClass("selected")
    @addClass("selected") if @file.selected()

  show_diff: =>
    @diff.html @file.diff()
