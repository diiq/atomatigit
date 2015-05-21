{View} = require 'atom-space-pen-views'

# Public: Visual representation of a {DiffLine}.
class DiffLineView extends View
  @content: (line) ->
    @div class: "diff-line #{line.type()}", =>
      @raw(line.markup())

  # Public: Constructor.
  initialize: (@model) -> return

module.exports = DiffLineView
