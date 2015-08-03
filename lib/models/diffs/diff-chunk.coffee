_    = require 'lodash'
fs   = require 'fs'
path = require 'path'

git       = require '../../git'
DiffLine  = require './diff-line'
ListItem  = require '../list-item'
ErrorView = require '../../views/error-view'

# Public: A {DiffChunk} represents one consecutive block of altered lines.
#
#   The end-goal of breaking them out separately is to be able to stage them
#   individually.
class DiffChunk extends ListItem
  # Public: Constructor.
  #
  # arguments - {Object}
  #   :header - The diff header used for patch generation as {String}.
  #   :chunk  - The chunk as {String}.
  initialize: ({@header, chunk}={}) ->
    @lines = _.map @splitIntoLines(chunk.trim()), (line) ->
      new DiffLine(line: line)

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
  patch: =>
    @get('header') + @get('chunk') + '\n'

  # Public: Revert this chunk.
  kill: =>
    fs.writeFileSync(@patchPath(), @patch())
    git.cmd "apply --reverse '#{@patchPath()}'"
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Stage this chunk.
  stage: =>
    fs.writeFileSync(@patchPath(), @patch())
    git.cmd "apply --cached '#{@patchPath()}'"
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Unstage this chunk.
  unstage: =>
    fs.writeFileSync(@patchPath(), @patch())
    git.cmd "apply --cached --reverse '#{@patchPath()}'"
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Internal: Return the path to the patch file.
  #
  # Returns the path as {String}.
  patchPath: ->
    path.join(
      atom.project.getRepositories()[0]?.getWorkingDirectory(),
      '.git/atomatigit_diff_patch'
    )

module.exports = DiffChunk
