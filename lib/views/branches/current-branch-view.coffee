{View} = require 'atom'

# Public: Visual representation of the current branch.
class CurrentBranchView extends View
  @content: ->
    @div class: 'current-branch-view', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'repaint', @repaint
    @repaint()

  # Public: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'repaint', @repaint

  # Public: Trigger a repaint.
  repaint: =>
    @name.html("#{@model.name}")
    @commit.html("(#{@model.commit.shortID?()}: #{@model.commit.shortMessage?()})")

    @commit.removeClass 'unpushed'
    @commit.addClass 'unpushed' if @model.unpushed()

module.exports = CurrentBranchView
