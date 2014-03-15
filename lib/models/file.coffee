{Model} = require 'backbone'
Diff = require './diff'

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
    @set
      selected: false
      diff: ""

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

  diff: ->
    @get "diff"

  repo: ->
    @get "repo"

  # Methods

  stage: ->
    @repo().add @filename(), @error_callback

  unstage: ->
    @repo().git "reset HEAD #{@filename()}", @error_callback

  set_diff: (diff) ->
    if not diff
      @set diff: null
    else
      @set diff: new Diff
        diff: diff
        file: self
        repo: @repo

  self_select: =>
    @collection.select @collection.indexOf(this)

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

  error_callback: (e, f, c )=>
    console.log e, f, c if e
    @trigger "repo:reload"
