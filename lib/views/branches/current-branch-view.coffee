{View} = require 'atom'

module.exports =
class CurrentBranchView extends View
  @content: ->
    @div class: "current-branch-view", =>
      @div class: "name", outlet: "name"
      @div class: "commit", outlet: "commit"

  initialize: (branch) ->
    @model = branch
    @model.on "change", @repaint
    @repaint()

  beforeRemove: ->
    @model.off "change", @repaint

  repaint: =>
    @name.html("#{@model.name()}")
    @commit.html("(#{@model.commit().shortID()}: #{@model.commit().shortMessage()})")

    @commit.removeClass "unpushed"
    if @model.unpushed()
      @commit.addClass "unpushed"
