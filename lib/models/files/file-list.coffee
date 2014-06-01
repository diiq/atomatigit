_ = require 'underscore'

List = require '../list'
UnstagedFile = require './unstaged-file'
StagedFile = require './staged-file'
UntrackedFile = require './untracked-file'
{git} = require '../../git'

module.exports =
class FileList extends List
  reload: ->
    git.status @populate

  populate: (filelist) =>
    filelist = @convertFileList(filelist)
    @populateList(filelist.untracked, @untracked(), UntrackedFile)
    @populateList(filelist.unstaged, @unstaged(), UnstagedFile)
    @populateList(filelist.staged, @staged(), StagedFile)

    @select @selected_index
    @trigger "repopulate"

  comparator: (file) ->
    file.sort_value

  staged: ->
    @filter (f) -> f.stagedP()

  unstaged: ->
    @filter (f) -> f.unstagedP()

  untracked: ->
    @filter (f) -> f.untrackedP()

  newPaths: (paths, files) ->
    _.filter paths, (path) ->
      not _.any files, (file) ->
        file.path() == path.path

  missingFiles: (paths, files) ->
    paths = @_filePathsFromPaths paths
    _.filter files, (file) ->
      not _.contains(paths, file.path())

  stillThereFiles: (paths, files) ->
    paths = @_filePathsFromPaths paths
    _.filter files, (file) ->
      _.contains(paths, file.path())

  _filePathsFromPaths: (paths) -> file.path for file in paths

  populateList: (paths, files, Klass) ->
    _.each @stillThereFiles(paths, files), (file) ->
      file.loadDiff()

    _.each @newPaths(paths, files), (path) =>
      @add new Klass path

    _.each @missingFiles(paths, files), (file) =>
      @remove file

  convertFileList: (files) ->
    filesStaged = []
    filesNotStaged = []
    filesNotTracked = []
    stateStaged = stateNotStaged = stateUntracked = false
    for own file, fileData of files
      fileData['path'] = file

      stateStaged = true if fileData.staged
      stateNotStaged = true if not fileData.staged and fileData.tracked
      stateUntracked = true if not fileData.tracked

      filesStaged.push fileData if fileData.staged
      filesNotStaged.push fileData if not fileData.staged and fileData.tracked
      filesNotTracked.push fileData if not fileData.tracked

    for file in filesStaged
      gitStatusType = file.type
      if gitStatusType?.length > 1
        stateNotStaged = true

        fileObjClone = _.clone(file)
        fileObjClone['type'] = gitStatusType.charAt(1)
        file.type = file.type?.charAt(0)

        # Rare case type 'RM', file has been renamed and modified
        fileObjClone.path = file.path.match(/(.*) -> (.*)/)?[2] if gitStatusType is 'RM'
        filesNotStaged.push fileObjClone

    {'staged': filesStaged, 'unstaged': filesNotStaged, 'untracked': filesNotTracked}
