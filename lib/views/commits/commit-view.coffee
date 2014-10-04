{View} = require 'atom'

# Public: Visual representation of a commit object.
class CommitView extends View
  @content: (commit) ->
    @div class: 'commit', click: 'clicked', =>
      @div class: 'id', "#{commit.shortID()}"
      @div class: 'author-name', "(#{commit.authorName()})"
      @div class: 'message text-subtle', "#{commit.shortMessage()}"

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'change:selected', @showSelection

  # Internal: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'change:selected', @showSelection

  # Internal: 'Clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Public: Show the selection.
  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = CommitView
