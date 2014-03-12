{View} = require 'atom'
BranchBriefView = require './branch-brief-view'

module.exports =
class BranchListView extends View
  @content: ->
    @div class: "branch-list-view", tabindex: -1, =>
      @h2 "local:"
      @div outlet: "local_dom"
      @h2 "remote:"
      @div outlet: "remote_dom"

  initialize: (branch_list) ->
    @branch_list = branch_list
    @branch_list.on "refresh", @repaint

  beforeRemove: ->
    @branch_list.off "refresh", @repaint

  empty_lists: ->
    @local_dom.empty()
    @remote_dom.empty()

  repaint: =>
    @empty_lists()

    for branch in @branch_list.local()
      console.log "IM A BRANCH", branch
      @local_dom.append(new BranchBriefView(branch))
    #
    # for branch in @branch_list.remote()
    #   @remote_dom.append new BranchBriefView branch
