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
  extractHeader: =>
    @header = @raw?.match(/^(.*?\n){2}/)?[0]

  # Public: Constructor
  #
  # diff - The raw diff as {String}.
  constructor: ({@raw, chunks}={}) ->
    @extractHeader()
    super _.map(chunks, (chunk) => {chunk: chunk, header: @header})

    @select -1

  # Public: Get the diff chunks.
  #
  # Returns the chunks as {Array}.
  chunks: ->
    @models

module.exports = Diff
