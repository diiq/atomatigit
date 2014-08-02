{View} = require 'atom'

class CurrentBranchView extends View
  @content: ->
    @div class: 'current-branch-view', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'

  initialize: (@model) ->
    @model.on 'repaint', @repaint
    @repaint()

  beforeRemove: =>
    @model.off 'repaint', @repaint

  repaint: =>
    @model.reload().then =>
      @name.html("#{@model.name}")
      @commit.html("(#{@model.commit.shortID()}: #{@model.commit.shortMessage()})")

      @commit.removeClass 'unpushed'
      if @model.unpushed()
        @commit.addClass 'unpushed'

module.exports = CurrentBranchView
