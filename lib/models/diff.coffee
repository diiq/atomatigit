DiffChunk = require './diff-chunk'
List = require './list'
_ = require 'underscore'

##
# A diff is a whole-file diff, and is broken into a list of chunks. End-game
# here is to be able to stage individual chunks, not just the whole diff.
#

module.exports =
class Diff extends List
  model: DiffChunk

  removeHeader: (diff) ->
    # Remove first two lines, which name the file
    diff.replace /^(.*?\n){2}/, ""

  splitChunks: (diff) ->
    # We'll treat "@@ " a the beginning of a line as characteristic of the start
    # of a chunk.
    diff.split /(?=^@@ )/gm

  constructor: (diff) ->
    diff = @removeHeader diff
    chunks = @splitChunks diff
    chunks = _.map chunks, (chunk) -> chunk: chunk
    super chunks

  chunks: ->
    @models
