_ = require 'underscore'

List = require '../list'
UnstagedFile = require './unstaged-file'
StagedFile = require './staged-file'
UntrackedFile = require './untracked-file'
{git} = require '../../git'

module.exports =
class FileList extends List
  reload: () ->
    git.status @populate

  populate: (filelist) =>
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
    _.filter paths, (path) =>
      not _.any files, (file) ->
        file.path() == path.path

  missingFiles: (paths, files) ->
    _.filter files, (file) =>
      not _.any paths, (path) ->
        file.path() == path.path

  stillThereFiles: (paths, files) ->
    _.filter files, (file) =>
      _.any paths, (path) ->
        file.path() == path.path

  populateList: (paths, files, Klass) ->
    _.each @stillThereFiles(paths, files), (file) =>
      file.loadDiff()

    _.each @newPaths(paths, files), (path) =>
      @add new Klass path

    _.each @missingFiles(paths, files), (file) =>
      @remove file
