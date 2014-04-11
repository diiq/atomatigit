DiffLine = require './diff-line'
ListItem = require './list-item'
_ = require 'underscore'

##
# A DiffChunk represents one consecutive block of altered lines. The end-goal of
# breaking them out separately is to be able to stage them individually.
#
module.exports =
class DiffChunk extends ListItem
  initialize: (chunk) ->
    chunk = @deleteFirstLine chunk
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
    lines = chunk.split /\n/g
