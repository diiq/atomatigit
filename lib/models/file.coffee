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
    @set selected: true

  unselect: ->
    @set selected: false

  selected: ->
    @get "selected"
