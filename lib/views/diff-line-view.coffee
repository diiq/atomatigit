{View} = require 'atom'

module.exports =
class DiffLineView extends View
  @content: (line) ->
    @div class: "diff-line #{line.type()}", =>
      @raw(line.markup())

  initialize: (line) ->
    @model = line
