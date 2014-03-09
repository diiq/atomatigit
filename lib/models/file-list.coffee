{Collection} = require 'backbone'
File = require './file'
_ = require 'underscore'

module.exports =
class FileList extends Collection
  model: File
  selected: 0

  refresh: (filehash) ->
    files = _.map filehash, (status, filename) =>
      new File
        filename: filename
        tracked: status.tracked
        staged: status.staged

    sorted_files = _.sortBy files, (f) ->
      f.sort_value()

    @reset(sorted_files)

    @trigger "refresh"
    @select 0

  selection: ->
    @at @selected

  select: (i) ->
    if @at @selected
      @at(@selected).unselect()

    @selected = Math.max(Math.min(i, @length - 1), 0)

    if @at @selected
      @at(@selected).select()

  staged: ->
    @filter (f) -> f.staged()

  unstaged: ->
    @filter (f) -> f.unstaged()

  untracked: ->
    @filter (f) -> f.untracked()

  next: ->
    @select @selected + 1

  previous: ->
    @select @selected - 1
