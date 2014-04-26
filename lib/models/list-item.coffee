{Model} = require 'backbone'

##
# There are multiple places that atomatigit requires lists of items, navigable
# by command/keybinding or by click. Some list items even have nested lists
# inside them. It's navigation hell! Still, we can abstract out some of that
# into List and ListItem. Victory, bitter but wingèd.

module.exports =
class ListItem extends Model
  selfSelect: =>
    # If this item was clicked, we need to tell the collection that it has
    # decided to be selected on its own.
    if @collection
      @collection.select @collection.indexOf(this)
    else
      @select()

  select: ->
    @set selected: true

  deselect: ->
    @set selected: false

  selectedP: ->
    @get "selected"

  allowPrevious: ->
    if @useSublist()
      not @sublist.previous()
    else
      true

  allowNext: ->
    if @useSublist()
      not @sublist.next()
    else
      true

  leaf: ->
    if @useSublist()
      @sublist.leaf() || this
    else
      this

  useSublist: -> false
