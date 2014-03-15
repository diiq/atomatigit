ListModel = require './list-model'
File = require './file'
_ = require 'underscore'

module.exports =
class FileList extends ListModel
  model: File

  initialize: (models, options) ->
    @repo = options.repo

  refresh: (filehash) ->
    @reset()
    _.each filehash, (status, filename) =>
      @add_from_refresh filename, status
      if status.type && status.type.length == 2
        status.staged = false
        @add_from_refresh filename, status

    @trigger "refresh"
    @select @selected

  add_from_refresh: (filename, status) ->
    file = @add
      filename: filename
      type: status.type
      tracked: status.tracked
      staged: status.staged
      repo: @repo
    file.on "repo:reload", =>
      @trigger "repo:reload"

  comparator: (file) ->
    file.sort_value()

  staged: ->
    @filter (f) -> f.staged()

  unstaged: ->
    @filter (f) -> f.unstaged()

  untracked: ->
    @filter (f) -> f.untracked()
