{View} = require 'atom'

module.exports =
class FileView extends View
  @content: (file) ->
    @div class: "file", "#{file.get 'filename'}"

  initialize: (file) ->
    @file = file
    @file.on "change", @select

  beforeRemove: ->
    @file.off "change", @select

  select: =>
    @removeClass("selected")
    @addClass("selected") if @file.selected()
