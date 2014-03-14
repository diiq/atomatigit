{Collection} = require 'backbone'
DiffLine = require './diff-line'
_ = require 'underscore'

module.exports =
##
# DiffChunk expects to be initialized with a object containing a string
# and a file:
# {
#   diff: "string",
#   file: File
# }

class DiffChunk extends Collection
  model: DiffLine

  constructor: (args) ->
    changes = args.diff.replace /.*?\n(\s*?\n)*/, ""
    changes = changes.replace /\s*$/, ""
    lines = changes.split /\n/g
    lines = _.map lines, (string) =>
      diff: string
      file: args.file
      repo: args.repo

    @string = args.diff
    @file = args.file
    @repo = args.repo

    super lines

  lines: ->
    @models
