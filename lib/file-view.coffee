{View} = require 'atom'

module.exports =
class FileView extends View
  @content: ->
    @div =>
      @div class: "file", outlet: "file_name"

  initialize: (filename, status) ->
    @file_name.append("#{filename}")
