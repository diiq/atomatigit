File      = require './file'
git       = require '../../git'
ErrorView = require '../../views/error-view'

module.exports =
class UnstagedFile extends File

  # Tracked files appear second in the file list
  sort_value: 1

  unstage: ->
    git.unstage(@path())
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  kill: ->
    atom.confirm
      message: "Discard unstaged changes to \"#{@path()}\"?"
      buttons:
        'Discard': @checkout
        'Cancel': -> return

  loadDiff: ->
    git.getDiff(@path())
    .then (diff) => @setDiff(diff)
    .catch (error) -> new ErrorView(error)

  isUnstaged: -> true
