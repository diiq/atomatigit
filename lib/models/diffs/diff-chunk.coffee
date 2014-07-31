_    = require 'underscore'
fs   = require 'fs'
path = require 'path'

{git}    = require '../../git'
DiffLine = require './diff-line'
ListItem = require '../list-item'


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

  patch: ->
    @get("header") + @get("chunk") + "\n"

  kill: ->
    fs.writeFileSync(@patchPath(), @patch())
    git.git "apply --reverse #{@patchPath()}"

  stage: ->
    fs.writeFileSync(@patchPath(), @patch())
    git.git "apply --cached #{@patchPath()}"

  unstage: ->
    fs.writeFileSync(@patchPath(), @patch())
    git.git "apply --cached --reverse #{@patchPath()}"

  patchPath: ->
    path.join git.getPath(), ".git/atomatigit_diff_patch"
