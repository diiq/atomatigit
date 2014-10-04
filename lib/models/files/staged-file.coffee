git       = require '../../git'
File      = require './file'
ErrorView = require '../../views/error-view'

class StagedFile extends File

  # Tracked files appear last in the file list
  sortValue: 2

  # Public: The file is already staged, empty function.
  stage: -> return

  # Public: Unstage the changes made to this file.
  unstage: =>
    git.unstage(@path())
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Ask for the user's confirmation to discard all changes made to this
  #         file.
  kill: =>
    atom.confirm
      message: "Discard all changes to \"#{@path()}\"?"
      buttons:
        'Discard': @discardAllChanges
        'Cancel': -> return

  # Internal: Discard all changes made to this file.
  discardAllChanges: =>
    @unstage()
    @checkout()

  # Internal: Update the diff.
  loadDiff: =>
    return if @getMode() is 'D'
    git.getDiff(@path(), {staged: true})
    .then (diff) => @setDiff(diff)
    .catch (error) -> new ErrorView(error)

  getMode: =>
    @get 'modeIndex'

  isStaged: -> true

module.exports = StagedFile
