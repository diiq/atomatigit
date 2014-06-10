File= require './file'
{git} = require '../../git'

module.exports =
class UnstagedFile extends File

  # Tracked files appear second in the file list
  sort_value: 1

  unstage: ->
    git.git "reset HEAD #{@path()}", @error_callback

  kill: ->
    atom.confirm
      message: "Discard unstaged changes to \"#{@path()}\"?"
      buttons:
        "Discard": @checkout
        "Cancel": -> null

  checkout: =>
    git.git "checkout #{@path()}"

  loadDiff: ->
    git.diff @path(), @setDiff

  unstagedP: -> true
