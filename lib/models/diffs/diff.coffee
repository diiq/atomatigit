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

  # Internal: Extract the 'header' property from the raw diff. The header is
  #           passed to each {DiffChunk} to be used in patch generation later.
  extractHeader: =>
    @header = @raw?.match(/^(.*?\n){2}/)?[0]

  # Public: Constructor
  #
  # arguments - {Object}
  #   :raw    - The raw diff as {String}.
  #   :chunks - The individual chunks as {Array} of {String}s.
  constructor: ({@raw, chunks}={}) ->
    @extractHeader()
    super _.map(chunks, (chunk) => {chunk: chunk, header: @header})

    @select -1

  # Public: Get the diff chunks.
  #
  # Returns the chunks as {Array}.
  chunks: =>
    @models

module.exports = Diff
