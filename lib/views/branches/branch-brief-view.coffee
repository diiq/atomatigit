{View} = require 'atom'

# Public: Visual representation of a brief branch.
class BranchBriefView extends View
  @content: ->
    @div class: 'branch-brief-view', mousedown: 'clicked', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    @repaint()

  # Public: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'change:selected', @showSelection

  # Public: 'clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Public: Trigger a repaint.
  repaint: =>
    @name.html("#{@model.getName()}")
    @commit.html("(#{@model.commit().shortID()}: #{@model.commit().shortMessage()})")

    @commit.removeClass 'unpushed'
    if @model.unpushed()
      @commit.addClass 'unpushed'

    @showSelection()

  # Public: Show the selection.
  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = BranchBriefView
