{Collection} = require 'backbone'

##
# There are multiple places that atomatigit requires lists of items, navigable
# by command/keybinding or by click. We do our best to abstract out what they
# have in common.
#

module.exports =
class List extends Collection
  selected_index: 0
  is_sublist: false

  leaf: ->
    if @selection()
      @selection().leaf()

  selection: ->
    @at @selected_index

  select: (i) ->
    old_selection = @selected_index
    if @selection()
      @selection().deselect()

    if @is_sublist and i < 0
      @selected_index = -1
      return false

    @selected_index = Math.max(Math.min(i, @length - 1), 0)

    if @selection()
      @selection().select()

    old_selection != @selected_index

  next: ->
    return false if @selection() and not @selection().allowNext()
    @select (@selected_index + 1)

  previous: ->
    return false if @selection() and not @selection().allowPrevious()
    @select(@selected_index - 1)
