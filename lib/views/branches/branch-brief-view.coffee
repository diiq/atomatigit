{View} = require 'atom'

module.exports =
class BranchBriefView extends View
  @content: ->
    @div class: "branch-brief-view", mousedown: "clicked", =>
      @div class: "name", outlet: "name"
      @div class: "commit", outlet: "commit"

  initialize: (branch) ->
    @model = branch
    @model.on "change:selected", @showSelection
    @model.on "change", @repaint
    @repaint()

  beforeRemove: ->
    @model.off "change:selected", @showSelection
    @model.off "change", @repaint

  clicked: =>
    @model.selfSelect()

  repaint: =>
    @name.html("#{@model.name()}")
    @commit.html("(#{@model.commit().shortID()}: #{@model.commit().shortMessage()})")

    @commit.removeClass "unpushed"
    if @model.unpushed()
      @commit.addClass "unpushed"

    @showSelection()

  showSelection: =>
    @removeClass("selected")
    @addClass("selected") if @model.selectedP()
