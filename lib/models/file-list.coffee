{Collection} = require 'backbone'
File = require './file'
_ = require 'underscore'

module.exports =
class FileList extends Collection
  model: File
  selected: 0

  refresh: (filehash) ->
    @reset()
    _.each filehash, (status, filename) =>
      @add
        filename: filename
        type: status.type
        tracked: status.tracked
        staged: status.staged

      if status.type && status.type.length == 2
        @add
          filename: filename
          type: status.type
          tracked: status.tracked
          staged: false

    @trigger "refresh"
    @select @selected

  comparator: (file) ->
    file.sort_value()

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
