{Collection} = require 'backbone'

# Public: There are multiple places that atomatigit requires lists of items,
#   navigable by command/keybinding or by click. We do our best to abstract out
#   what they have in common.
class List extends Collection
  selectedIndex: 0
  isSublist: false

  # Public: Leaf??
  #
  # Returns the leaf as {???}.
  leaf: ->
    if @selection()
      @selection().leaf()

  # Public: Returns the selected entry.
  #
  # Returns the selected entry as {ListItem}.
  selection: ->
    @at @selectedIndex

  # Public: Select a {ListItem} from this List.
  #
  # i - The item to select as {ListItem}.
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

  # Public: Select the next item from the List.
  next: ->
    return false if @selection() and not @selection().allowNext()
    @select (@selectedIndex + 1)

  # Public: Select the previous item in the List.
  previous: ->
    return false if @selection() and not @selection().allowPrevious()
    @select(@selectedIndex - 1)

module.exports = List
