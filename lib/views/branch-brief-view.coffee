##
# This

{View} = require 'atom'

module.exports =
class BranchBriefView extends View
  @content: ->
    @div class: "branch-brief-view", =>
      @h1 class: "name", outlet: "name"
      @div class: "commit", outlet: "commit"

  initialize: (branch) ->
    @branch = branch
    @branch.on "change", @repaint

  beforeRemove: ->
    @branch.off "change", @repaint

  repaint: =>
    @name.html("#{@branch.name()}")
    @commit.html("(#{@branch.short_commit_id()}: #{@branch.short_commit_message()})")
    if @branch.unpushed()
      @commit.addClass "unpushed"
