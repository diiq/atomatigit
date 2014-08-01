{Collection} = require 'backbone'

##
# There are multiple places that atomatigit requires lists of items, navigable
# by command/keybinding or by click. We do our best to abstract out what they
# have in common.
#

module.exports =
class List extends Collection
  selectedIndex: 0
  isSublist: false

  leaf: ->
    if @selection()
      @selection().leaf()

  selection: ->
    @at @selectedIndex

  select: (i) ->
    old_selection = @selectedIndex
    if @selection()
      @selection().deselect()

    if @isSublist and i < 0
      @selectedIndex = -1
      return false

    @selectedIndex = Math.max(Math.min(i, @length - 1), 0)

    if @selection()
      @selection().select()

    old_selection != @selectedIndex

  next: ->
    return false if @selection() and not @selection().allowNext()
    @select (@selectedIndex + 1)

  previous: ->
    return false if @selection() and not @selection().allowPrevious()
    @select(@selectedIndex - 1)
