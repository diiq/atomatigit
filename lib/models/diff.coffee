{Collection} = require 'backbone'
DiffChunk = require './diff-chunk'
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

class Diff extends Collection
  model: DiffChunk

  constructor: (args) ->
    console.log args.diff
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

    console.log @models

  chunks: ->
    @models

  diff: ->
    @string
