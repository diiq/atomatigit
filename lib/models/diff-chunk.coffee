{Collection} = require 'backbone'
ListItemModel = require './list-item-model'
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

class DiffChunk extends ListItemModel
  initialize: (args) ->
    @list = new DiffLines(args, self)

  lines: ->
    @list.lines()


class DiffLines extends Collection
  model: DiffLine

  constructor: (args, chunk) ->
    @chunk = chunk
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
