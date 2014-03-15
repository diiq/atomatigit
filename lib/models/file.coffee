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

  kill: ->
    if @untracked()
      message = "Delete untracked file \"#{@filename()}\"?"
    else
      message = "Discard all changes to \"#{@filename()}\"?"

    atom.confirm
      message: message
      buttons:
        "Discard": => @kill_no_confirm()
        "Cancel": null

  kill_no_confirm: ->
    if @unstaged()
      @repo().git "checkout #{@filename()}", @error_callback
    else if @untracked()
      @repo().add @filename(), =>
        @repo().git "rm -f #{@filename()}", @error_callback
    else if @staged()
      @repo().git "reset HEAD #{@filename()}", =>
        @repo().git "checkout #{@filename()}", @error_callback

  open: ->
    filename = @current_file().filename()
    atom.workspaceView.open(filename)

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
