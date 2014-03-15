{Model} = require 'backbone'

module.exports =
class ListItemModel extends Model
  self_select: =>
    @collection.select @collection.indexOf(this)

  select: ->
    @set selected: true

  unselect: ->
    @set selected: false

  selected: ->
    @get "selected"
