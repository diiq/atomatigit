
{Collection} = require 'backbone'
_ = require 'underscore'

module.exports =
class ListModel extends Collection
  selected: 0

  constructor: (args, options) ->
    super args, options

  selection: ->
    @at @selected

  select: (i) ->
    if @at @selected
      @at(@selected).unselect()

    @selected = Math.max(Math.min(i, @length - 1), 0)

    if @at @selected
      @at(@selected).select()

  next: ->
    @select @selected + 1

  previous: ->
    @select @selected - 1
