{View} = require 'atom'

class BranchBriefView extends View
  @content: ->
    @div class: 'branch-brief-view', mousedown: 'clicked', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'

  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    @repaint()

  beforeRemove: =>
    @model.off 'change:selected', @showSelection

  clicked: =>
    @model.selfSelect()

  repaint: =>
    @name.html("#{@model.getName()}")
    @commit.html("(#{@model.commit().shortID()}: #{@model.commit().shortMessage()})")

    @commit.removeClass 'unpushed'
    if @model.unpushed()
      @commit.addClass 'unpushed'

    @showSelection()

  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = BranchBriefView
