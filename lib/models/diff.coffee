{Collection} = require 'backbone'
DiffChunk = require './diff-chunk'
ListModel = require './list-model'
_ = require 'underscore'

module.exports =
##
# Diff expects to be initialized with a object containing a string
# and a file:
# {
#   diff: "string",
#   file: File,
#   repo: Repo
# }

class Diff extends ListModel
  model: DiffChunk

  constructor: (args) ->
    chunkstrings = args.diff.split /\n@@/g
    chunkstrings = chunkstrings.slice 1, chunkstrings.length
    chunks = _.map chunkstrings, (string) =>
      diff: string
      file: args.file
      repo: args.repo

    @string = args.diff
    @file = args.file
    @repo = args.repo

    super chunks

  chunks: ->
    @models

  diff: ->
    @string
