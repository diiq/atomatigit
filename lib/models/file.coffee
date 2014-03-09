{Model} = require 'backbone'

module.exports =
##
# File expects to be initialized with an object:
# {
#   filename: "string",
#   staged: bool,
#   tracked: bool
# }
class File extends Model
  initialize: ->
    @set selected: false

  unstaged: ->
    !(@get "staged") && (@get "tracked")

  untracked: ->
    !(@get "tracked")

  staged: ->
    @get "staged"

  select: ->
    console.log "OK SELECT", @get "selected"
    @set selected: true
    console.log "OK SELECTED", @get "selected"

  unselect: ->
    console.log "OK UNSELECT", @get "selected"
    @set selected: false
    console.log "OK UNSELECTED", @get "selected"

  selected: ->
    @get "selected"
