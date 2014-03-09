{Collection} = require 'backbone'
File = require './file'

module.exports =
class FileList extends Collection
  model: File
  selected: 0

  refresh: (files) ->
    @reset()
    for filename, status of files
      @add
        filename: filename
        tracked: status.tracked
        staged: status.staged
    @select 0

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
