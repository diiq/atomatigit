{Collection} = require 'backbone'

##
# There are multiple places that atomatigit requires lists of items, navigable
# by command/keybinding or by click. We do our best to abstract out what they
# have in common.
#

module.exports =
class List extends Collection
  selected_index: 0

  selection: ->
    @at @selected_index

  select: (i) ->
    old_selection = @selected_index
    if @selection()
      @selection().deselect()

    @selected_index = Math.max(Math.min(i, @length - 1), 0)

    if @selection()
      @selection().select()

    old_selection != @selected_index

  next: ->
    @selection().allowNext() && @select(@selected_index + 1)

  previous: ->
    @selection().allowPrevious() && @select(@selected_index - 1)
