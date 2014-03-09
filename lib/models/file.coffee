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

  # Accessors

  unstaged: ->
    !(@get "staged") && (@get "tracked")

  untracked: ->
    !(@get "tracked")

  staged: ->
    @get "staged"

  selected: ->
    @get "selected"

  filename: ->
    @get "filename"

  # Methods

  # We get files in any old order, and want to sort them by staged, unstaged,
  # untracked. This value makes that easier.
  sort_value: ->
    return 2 if @staged()
    return 0 if @untracked()
    return 1

  select: ->
    @set selected: true

  unselect: ->
    @set selected: false
