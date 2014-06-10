shell = require 'shell'

File = require './file'
{git} = require '../../git'

module.exports =
class StagedFile extends File

  # Tracked files appear last in the file list
  sort_value: 2

  stage: ->
    null

  unstage: ->
    git.git "reset HEAD #{@path()}"

  kill: ->
    atom.confirm
      message: "Discard all changes to \"#{@path()}\"?"
      buttons:
        "Discard": @discardAllChanges
        "Cancel": -> null

  discardAllChanges: =>
    git.git "reset HEAD #{@path()}", =>
      git.git "checkout #{@path()}"

  loadDiff: ->
    git.diff @path(), @setDiff, flags: "--staged"

  stagedP: -> true
