{View} = require 'atom'

module.exports =
class BranchBriefView extends View
  @content: ->
    @div class: "branch-brief-view", click: "clicked" =>
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

  clicked: ->
    @model.selfSelect()

  repaint: =>
    @name.html("#{@model.name()}")
    @commit.html("(#{@model.short_commit_id()}: #{@model.short_commit_message()})")

    @commit.removeClass "unpushed"
    if @model.unpushed()
      @commit.addClass "unpushed"

  showSelection: =>
    @removeClass("selected")
    @addClass("selected") if @model.selectedP()
