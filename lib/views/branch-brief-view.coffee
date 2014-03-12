##
# This

{View} = require 'atom'

module.exports =
class BranchBriefView extends View
  @content: ->
    @div class: "branch-brief-view", =>
      @div class: "name", outlet: "name"
      @div class: "commit", outlet: "commit"

  initialize: (branch) ->
    @model = branch
    @repaint()
    @model.on "change:selected", @select
    @model.on "change", @repaint
    @on "click", => @model.self_select()

  beforeRemove: ->
    @model.off "change", @repaint

  repaint: =>
    @name.html("#{@model.name()}")
    @commit.html("(#{@model.short_commit_id()}: #{@model.short_commit_message()})")

    @commit.removeClass "unpushed"
    if @model.unpushed()
      @commit.addClass "unpushed"

  select: =>
    @removeClass("selected")
    @addClass("selected") if @model.selected()
