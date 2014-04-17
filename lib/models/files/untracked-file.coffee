shell = require 'shell'

File = require './file'

{git} = require '../../git'

module.exports =
class UntrackedFile extends File

  # Untracked files appear first in the list
  sort_value: 0

  kill: =>
    atom.confirm
      message: "Move \"#{@path()}\" to trash?"
      buttons:
        "Trash": @moveToTrash
        "Cancel": null

  moveToTrash: =>
    shell.moveItemToTrash(git.path + "/" + @path())
    git.trigger "reload"

  untrackedP: -> true

  toggleDiff: -> null
