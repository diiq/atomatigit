{View} = require 'atom'

class CurrentBranchView extends View
  @content: ->
    @div class: 'current-branch-view', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'

  initialize: (@model) ->
    @model.on 'change', @repaint
    @repaint()

  beforeRemove: =>
    @model.off 'change', @repaint

  repaint: =>
    @model.reload().then =>
      console.log @name
      @name.html("#{@model.name}")
      @commit.html("(#{@model.commit.shortID()}: #{@model.commit.shortMessage()})")
      console.log @model.name
      console.log @model.commit.shortID()

      @commit.removeClass 'unpushed'
      if @model.unpushed()
        @commit.addClass 'unpushed'

module.exports = CurrentBranchView
