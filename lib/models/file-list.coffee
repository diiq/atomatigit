List = require './list'
UnstagedFile = require './unstaged-file'
StagedFile = require './staged-file'
UntrackedFile = require './untracked-file'
_ = require 'underscore'

module.exports =
class FileList extends List
  populate: (filelist) ->
    @reset()

    _.each filelist.untracked, (file) =>
      @add new UntrackedFile file

    _.each filelist.unstaged, (file) =>
      @add new UnstagedFile file

    _.each filelist.staged, (file) =>
      @add new StagedFile file

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
