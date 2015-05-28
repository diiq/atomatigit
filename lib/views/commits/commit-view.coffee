{View} = require 'atom-space-pen-views'

# Public: Visual representation of a commit object.
class CommitView extends View
  @content: (commit) ->
    @div class: 'commit', click: 'clicked', =>
      @div class: 'id', "#{commit.shortID()}"
      @div class: 'author-name', "(#{commit.authorName()})"
      @div class: 'message text-subtle', "#{commit.shortMessage()}"

  # Public: Constructor.
  initialize: (@model) ->

  # Public: 'attached' hook.
  attached: =>
    @model.on 'change:selected', @showSelection

  # Internal: 'detached' handler.
  detached: =>
    @model.off 'change:selected', @showSelection

  # Internal: 'Clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Public: Show the selection.
  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = CommitView
