git  = require '../../git'
File = require './file'

class StagedFile extends File

  # Tracked files appear last in the file list
  sort_value: 2

  # Public: The file is already staged, empty function.
  stage: -> return

  # Public: Unstage the changes made to this file.
  unstage: ->
    git.unstage @path()

  # Public: Ask for the user's confirmation to discard all changes made to this
  #         file.
  kill: ->
    atom.confirm
      message: "Discard all changes to \"#{@path()}\"?"
      buttons:
        'Discard': @discardAllChanges
        'Cancel': -> return

  # Internal: Discard all changes made to this file.
  discardAllChanges: ->
    @unstage()
    @checkout()

  # Internal: Update the diff.
  loadDiff: ->
    git.getDiff(@path(), {staged: true}).then (diff) => @setDiff(diff)

  stagedP: -> true

module.exports = StagedFile
