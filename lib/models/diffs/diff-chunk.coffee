_    = require 'lodash'
fs   = require 'fs'
path = require 'path'

git    = require '../../git'
DiffLine = require './diff-line'
ListItem = require '../list-item'

# Public: A {DiffChunk} represents one consecutive block of altered lines.
#
#   The end-goal of breaking them out separately is to be able to stage them
#   individually.
class DiffChunk extends ListItem
  # Public: Constructor.
  #
  # options - The options as {Object}.
  initialize: (options) ->
    chunk = @deleteFirstLine options.chunk
    chunk = @deleteInitialWhitespace chunk
    chunk = @deleteTrailingWhitespace chunk
    @lines = _.map @splitIntoLines(chunk), (line) ->
      new DiffLine line: line

  # Internal: Deletes trailing whitespaces from chunk.
  #
  # chunk - The chunk as {String}.
  #
  # Returns the chunk without the trailing whitespaces as {String}.
  deleteTrailingWhitespace: (chunk) ->
    chunk.replace /\s*$/, ''

  # Internal: Deletes the first line from chunk.
  #
  # chunk - The chunk as {String}.
  #
  # Returns the chunk without the first line as {String}.
  deleteFirstLine: (chunk) ->
    chunk.replace /.*?\n/, ''

  # Internal: Deletes initial whitespaces from chunk.
  #
  # chunk - The chunk as {String}.
  #
  # Returns the chunk without the initial whitespaces as {String}.
  deleteInitialWhitespace: (chunk) ->
    chunk.replace /^(\s*?\n)*/, ''

  # Internal: Splits chunk into singles lines.
  #
  # chunk - The chunk as {String}.
  #
  # Returns the chunk split into single lines as {Array}.
  splitIntoLines: (chunk) ->
    chunk.split /\n/g

  # Internal: Generate a git patch for this {DiffChunk}.
  #
  # Returns the patch as {String}.
  patch: ->
    @get('header') + @get('chunk') + '\n'

  # Public: Revert this chunk.
  kill: ->
    fs.writeFileSync(@patchPath(), @patch())
    git.cmd "apply --reverse #{@patchPath()}"

  # Public: Stage this chunk.
  stage: ->
    fs.writeFileSync(@patchPath(), @patch())
    git.cmd "apply --cached #{@patchPath()}"

  # Public: Unstage this chunk.
  unstage: ->
    fs.writeFileSync(@patchPath(), @patch())
    git.cmd "apply --cached --reverse #{@patchPath()}"

  # Internal: Return the path to the patch file.
  #
  # Returns the path as {String}.
  patchPath: ->
    path.join(
      atom.project.getRepo()?.getWorkingDirectory(),
      '.git/atomatigit_diff_patch'
    )

module.exports = DiffChunk
