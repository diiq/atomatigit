{Model} = require 'backbone'

# Public: There are multiple places that atomatigit requires lists of items,
#   navigable by command/keybinding or by click. Some list items even have
#   nested lists inside them. It's navigation hell! Still, we can abstract out
#   some of that into List and ListItem. Victory, bitter but winged.
class ListItem extends Model
  # Public: Select this item.
  #
  #   If this item was clicked, we need to tell the collection that it has
  #   decided to be selected on its own.
  selfSelect: =>
    if @collection
      @collection.select @collection.indexOf(this)
    else
      @select()

  # Internal: Set the 'selected' property to true.
  select: =>
    @set selected: true

  # Internal: Set the 'selected' property to false.
  deselect: =>
    @set selected: false

  # Public: Check if item is currently selected
  #
  # Returns: {Boolean}
  isSelected: =>
    @get 'selected'

  # Public:
  #
  # Returns: {Boolean}
  allowPrevious: =>
    if @useSublist()
      not @sublist?.previous()
    else
      true

  # Public:
  #
  # Returns: {Boolean}
  allowNext: =>
    if @useSublist()
      not @sublist?.next()
    else
      true

  # Public: Leaf???
  #
  # Returns the leaf as {Object}.
  leaf: =>
    if @useSublist()
      @sublist.leaf() || this
    else
      this

  useSublist: -> false

module.exports = ListItem
