{Model} = require 'backbone'

module.exports =
##
# DiffChunk expects to be initialized with a object containing a string
# and a file:
# {
#   diff: "string",
#   file: File
# }

class DiffChunk extends Model
  markup: ->
    diff = diff.replace /[\r\n]/g, "<br/>"
    diff = diff.replace /\s(?=\s)/g, "&nbsp;"

  string: ->
    @get "chunk"

  repo: ->
    @get "repo"

  diff: ->
    @get "diff"
