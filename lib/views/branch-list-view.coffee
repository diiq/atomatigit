{View} = require 'atom'
BranchBriefView = require './branch-brief-view'

module.exports =
class BranchListView extends View
  @content: ->
    @div class: "branch-list-view list-view", tabindex: -1, =>
      @h2 "local:"
      @div outlet: "local_dom"
      @h2 "remote:"
      @div outlet: "remote_dom"

  initialize: (branch_list) ->
    @model = branch_list
    @model.on "change", @repaint

  beforeRemove: ->
    @model.off "change", @repaint

  empty_lists: ->
    @local_dom.empty()
    @remote_dom.empty()

  repaint: =>
    @empty_lists()

    for branch in @model.local()
      @local_dom.append new BranchBriefView branch

    for branch in @model.remote()
      @remote_dom.append new BranchBriefView branch
