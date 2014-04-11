DiffLine = require './diff-line'
ListItem = require './list-item'
_ = require 'underscore'

##
# A DiffChunk represents one consecutive block of altered lines. The end-goal of
# breaking them out separately is to be able to stage them individually.
#
module.exports =
class DiffChunk extends ListItem
  initialize: (options) ->
    chunk = @deleteFirstLine options.chunk
    chunk = @deleteInitialWhitespace chunk
    chunk = @deleteTrailingWhitespace chunk
    @lines = _.map @splitIntoLines(chunk), (line) ->
      new DiffLine line: line

  deleteTrailingWhitespace: (chunk) ->
    chunk.replace /\s*$/, ""

  deleteFirstLine: (chunk) ->
    chunk.replace /.*?\n/, ""

  deleteInitialWhitespace: (chunk) ->
    chunk.replace /^(\s*?\n)*/, ""

  splitIntoLines: (chunk) ->
    chunk.split /\n/g
