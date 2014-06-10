DiffChunk = require './diff-chunk'
List = require '../list'
_ = require 'underscore'

##
# A diff is a whole-file diff, and is broken into a list of chunks. End-game
# here is to be able to stage individual chunks, not just the whole diff.
#

module.exports =
class Diff extends List
  model: DiffChunk
  is_sublist: true
  selected_index: -1

  removeHeader: (diff) ->
    # Remove first two lines, which name the file
    @header = diff?.match(/^(.*?\n){2}/)?[0]
    diff?.replace /^(.*?\n){2}/, ""

  splitChunks: (diff) ->
    # We'll treat "@@ " a the beginning of a line as characteristic of the start
    # of a chunk.
    diff?.split /(?=^@@ )/gm

  constructor: (diff) ->
    @giftDiff = diff
    @raw = diff?.diff
    diff = @removeHeader @raw
    chunks = @splitChunks diff
    chunks = _.map chunks, (chunk) => chunk: chunk, header: @header
    super chunks

    @select -1

  chunks: ->
    @models
