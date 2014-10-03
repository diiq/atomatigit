_       = require 'lodash'
{Model} = require 'backbone'

# Public: {DiffLine} represents a single line of a diff.
#
#   Someday we might want to be able to jump straight to this line, but for now
#   it only needs to manage whether it is an addition, subtraction, or context
#   line.
class DiffLine extends Model
  # Public: Returns the contents of the DiffLine.
  #
  # Returns the diff line as {String}.
  line: =>
    @get 'line'

  # Public: Return the type of diff this line is.
  #
  # Returns the type as {String}:
  #   'addition': '+'
  #   'subtraction': '-'
  #   'context': 'context'
  type: =>
    if @line().match(/^\+/)
      'addition'
    else if @line().match(/^\-/)
      'subtraction'
    else
      'context'

  # Public: Returns the 'repo' property.
  #
  # Returns the 'repo' property as {String}.
  repo: =>
    @get 'repo'

  # Public: Return the HTML rendered line content.
  #
  # Returns the rendered line content as {String}.
  markup: =>
    @escapeHTML @line()

  # Internal: HTML escape a string.
  #
  # string - The string to escape as {String}.
  #
  # Returns the html escaped string as {String}.
  escapeHTML: (string) ->
    entityMap =
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
      "'": '&#39;'
      '/': '&#x2F;'
      ' ': '&nbsp;'
    if _.isString(string)
      string.replace /[&<>"'\/ ]/g, (s) -> entityMap[s]
    else
      string

module.exports = DiffLine
