File      = require './file'
git       = require '../../git'
ErrorView = require '../../views/error-view'

module.exports =
class UnstagedFile extends File

  # Tracked files appear second in the file list
  sortValue: 1

  unstage: =>
    git.unstage(@path())
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  kill: =>
    atom.confirm
      message: "Discard unstaged changes to \"#{@path()}\"?"
      buttons:
        'Discard': @checkout
        'Cancel': -> return

  loadDiff: =>
    return if @getMode() is 'D'
    git.getDiff(@path())
    .then (diff) => @setDiff(diff)
    .catch (error) -> new ErrorView(error)

  getMode: =>
    @get 'modeWorkingTree'

  isUnstaged: -> true
