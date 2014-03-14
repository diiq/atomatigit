{Model} = require 'backbone'

module.exports =
##
# DiffChunk expects to be initialized with a object containing a string
# and a file:
# {
#   diff: "string",
#   file: File
# }

class DiffLine extends Model
  initialize: (args) ->
    string = @diff()
    @set
      addition: !!(string.match /^\s*\+/)
      subtraction: !!(string.match /^\s*\-/)
      string: string

  diff: ->
    @get "diff"

  addition: ->
    @get "addition"

  subtraction: ->
    @get "subtraction"

  context: ->
    !(@addition() || @subtraction)

  repo: ->
    @get "repo"

  markup: ->
    @get("string").replace /\ /, "&nbsp;"
