_         = require 'lodash'
List      = require '../list'
DiffChunk = require './diff-chunk'

# Public: A {Diff} is a whole-file diff and is broken into a list of chunks.
#
#   End-game here is to be able to stage individual chunks, not just the whole
#   diff.
class Diff extends List
  model: DiffChunk
  isSublist: true
  selectedIndex: -1

  # Internal: Remove the first two lines, which name the file and save them as
  #   'header' property.
  #
  # diff - The raw diff as {String}.
  #
  # Returns the diff minus the first two lines as {String}.
  removeHeader: (diff) ->
    @header = diff?.match(/^(.*?\n){2}/)?[0]
    diff?.replace /^(.*?\n){2}/, ''

  # Internal: Split the remining diff into chunks.
  #
  # We will treat '@@' at the beginning of a line as characteristic of the
  # start of a new diff chunk.
  #
  # diff - The remaining raw diff as {String}.
  #
  # Returns the chunks as {Array}.
  splitChunks: (diff) ->
    diff?.split /(?=^@@ )/gm

  # Public: Constructor
  #
  # diff - The raw diff as {String}.
  constructor: (diff) ->
    @giftDiff = diff
    @raw = diff?.diff
    diff = @removeHeader(@raw)
    chunks = @splitChunks(diff)
    chunks = _.map chunks, (chunk) => {chunk: chunk, header: @header}
    super(chunks)

    @select -1

  # Public: Get the diff chunks.
  #
  # Returns the chunks as {Array}.
  chunks: ->
    @models

module.exports = Diff
