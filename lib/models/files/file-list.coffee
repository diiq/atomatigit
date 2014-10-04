_ = require 'lodash'

git           = require '../../git'
List          = require '../list'
StagedFile    = require './staged-file'
UnstagedFile  = require './unstaged-file'
UntrackedFile = require './untracked-file'
ErrorView     = require '../../views/error-view'

class FileList extends List
  # Public: Reload the file list.
  reload: ({silent}={}) =>
    git.status()
    .then (status) => @populate(status, silent)
    .catch (error) -> new ErrorView(error)

  # Internal: Populate the file list.
  #
  # status - The status to populate the file list with as {Object}.
  populate: (status, silent) =>
    @reset()

    @populateList(status.untracked, UntrackedFile)
    @populateList(status.unstaged, UnstagedFile)
    @populateList(status.staged, StagedFile)

    @select(@selectedIndex ? 0)
    @trigger('repaint') unless silent

  # Public: Return the staged files.
  staged: =>
    @filter (file) -> file.isStaged()

  # Public: Return the unstaged files.
  unstaged: =>
    @filter (file) -> file.isUnstaged()

  # Public: Return the untracked files.
  untracked: =>
    @filter (file) -> file.isUntracked()

  # Internal: Populate the list.
  #
  # files - The files to populate the list with as {Array}.
  # Klass - The Klass these paths are to be tracked as as {Object}.
  populateList: (files, Klass) =>
    _.each files, (file) => @add new Klass(file)

module.exports = FileList
