{Collection} = require 'backbone'

# Public: There are multiple places that atomatigit requires lists of items,
#   navigable by command/keybinding or by click. We do our best to abstract out
#   what they have in common.
class List extends Collection
  selectedIndex: 0
  isSublist: false

  # Public: Constructor
  initialize: ->
    @on 'update', @reload

  # Public: Leaf??
  #
  # Returns the leaf as {???}.
  leaf: =>
    @selection()?.leaf()

  # Public: Returns the selected entry.
  #
  # Returns the selected entry as {ListItem}.
  selection: =>
    @at @selectedIndex

  # Public: Select a {ListItem} from this List.
  #
  # i - The item to select as {ListItem}.
  select: (i) =>
    oldSelection = @selectedIndex
    @selection().deselect() if @selection()

    if @isSublist and i < 0
      @selectedIndex = -1
      return false

    @selectedIndex = Math.max(Math.min(i, @length - 1), 0)
    @selection()?.select()

    @selectedIndex isnt oldSelection

  # Public: Select the next item from the List.
  next: =>
    return false if @selection() and not @selection().allowNext()
    @select (@selectedIndex + 1)

  # Public: Select the previous item in the List.
  previous: =>
    return false if @selection() and not @selection().allowPrevious()
    @select(@selectedIndex - 1)

  # Abstract: Method to be called when reloading the list.
  reload: -> return

module.exports = List
