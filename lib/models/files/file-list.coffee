_ = require 'lodash'

git           = require '../../git'
List          = require '../list'
UnstagedFile  = require './unstaged-file'
StagedFile    = require './staged-file'
UntrackedFile = require './untracked-file'

class FileList extends List
  # Public: Reload the file list.
  reload: ->
    git.status().then (status) => @populate(status)

  # Internal: Populate the file list.
  #
  # status - The status to populate the file list with as {Object}.
  populate: (status) ->
    @populateList(_.map(status.untracked, 'path'), @untracked(), UntrackedFile)
    @populateList(_.map(status.unstaged, 'path'), @unstaged(), UnstagedFile)
    @populateList(_.map(status.staged, 'path'), @staged(), StagedFile)

    @select @selectedIndex
    @trigger 'repopulate'

  comparator: (file) ->
    file.sort_value

  # Public: Return the staged files.
  staged: ->
    @filter (f) -> f.stagedP()

  # Public: Return the unstaged files.
  unstaged: ->
    @filter (f) -> f.unstagedP()

  # Public: Return the untracked files.
  untracked: ->
    @filter (f) -> f.untrackedP()

  # Internal: Which of the paths are new?
  #
  # paths - The paths to test as {Array}.
  # files - The known file paths as {Array}.
  #
  # Returns the new paths as {Array}.
  newPaths: (paths, files) ->
    _.filter paths, (path) ->
      not _.any files, (file) ->
        file.path() == path.path

  # Internal: Which of the known files are missing?
  #
  # paths - The paths to test as {Array}.
  # files - The known file paths as {Array}.
  #
  # Returns the missing file paths as {Array}.
  missingFiles: (paths, files) ->
    paths = _.map(paths, 'path')
    _.filter files, (file) ->
      not _.contains(paths, file.path())

  # Public: Which of the known files are still there?
  #
  # paths - The paths to test as {Array}.
  # files - The known file paths as {Array}.
  #
  # Returns the paths of the files that are still there as {Array}.
  stillThereFiles: (paths, files) ->
    paths = _.map(paths, 'path')
    _.filter files, (file) ->
      _.contains(paths, file.path())

  # Internal: Populate the list.
  #
  # paths - The paths to populate with as {Array}.
  # files - The already tracked files as {Array}.
  # Klass - The Klass these paths are to be tracked as as {Object}.
  populateList: (paths, files, Klass) ->
    _.each @stillThereFiles(paths, files), (file) ->
      file.loadDiff()

    _.each @newPaths(paths, files), (path) =>
      @add new Klass path

    _.each @missingFiles(paths, files), (file) =>
      @remove file

module.exports = FileList
