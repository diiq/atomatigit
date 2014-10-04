git  = require '../../git'
File = require './file'

module.exports =
class UntrackedFile extends File

  # Untracked files appear first in the list
  sortValue: 0

  kill: =>
    atom.confirm
      message: "Move \"#{@path()}\" to trash?"
      buttons:
        'Trash': @moveToTrash
        'Cancel': null

  moveToTrash: =>
#   shell.moveItemToTrash(git.path + '/' + @path())
    @trigger 'update'

  isUntracked: -> true

  toggleDiff: -> return
