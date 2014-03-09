{View} = require 'atom'

module.exports =
class FileView extends View
  @content: (file) ->
    @div class: "file", "#{file.get 'filename'}"

  initialize: (file) ->
    @file = file
    @file.on "change", @select

  select: =>
    console.log "selected view", @file
    @removeClass("selected")
    @addClass("selected") if @file.selected()
