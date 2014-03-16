ListItemModel = require './list-item-model'
Diff = require './diff'
error_model = require '../error-model'

module.exports =
##
# File expects to be initialized with an object:
# {
#   filename: "string",
#   staged: bool,
#   tracked: bool
# }
class File extends ListItemModel
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
        "Discard": => @kill_on_sight()
        "Cancel": null

  kill_on_sight: ->
    if @unstaged()
      @repo().git "checkout #{@filename()}", @error_callback
    else if @untracked()
      @repo().add @filename(), =>
        @repo().git "rm -f #{@filename()}", @error_callback
    else if @staged()
      @repo().git "reset HEAD #{@filename()}", =>
        @repo().git "checkout #{@filename()}", @error_callback


  toggle_diff: ->
    if @diff()
      @set diff: null
      return

    flags = ""
    if @staged()
      flags += "--staged "

    @repo().diff flags, "", @filename(), (e, diffs) =>
      console.log e
      if not e
        @set diff: new Diff
          diff: diffs[0].diff
          file: self
          repo: @repo()


  open: ->
    atom.workspaceView.open @filename()

  set_diff: (diff) ->
    if not diff
      @set diff: null
    else
      @set diff: new Diff
        diff: diff
        file: self
        repo: @repo

  # We get files in any old order, and want to sort them by staged, unstaged,
  # untracked. This value makes that easier.
  sort_value: ->
    return 2 if @staged()
    return 0 if @untracked()
    return 1

  error_callback: (e, f, c)=>
    error_model.set_message "#{e}\n#{f}\n#{c}" if e
    @trigger "repo:reload"
