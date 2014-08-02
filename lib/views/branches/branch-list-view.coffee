{View} = require 'atom'
BranchBriefView = require './branch-brief-view'

class BranchListView extends View
  @content: ->
    @div class: 'branch-list-view list-view', tabindex: -1, =>
      @h2 'local:'
      @div outlet: 'localDom'
      @h2 'remote:'
      @div outlet: 'remoteDom'

  initialize: (@model) ->
    @model.on 'change', @repaint

  beforeRemove: =>
    @model.off 'change', @repaint

  empty_lists: =>
    @localDom.empty()
    @remoteDom.empty()

  repaint: =>
    @empty_lists()

    for branch in @model.local()
      @localDom.append new BranchBriefView(branch)

    for branch in @model.remote()
      @remoteDom.append new BranchBriefView(branch)

module.exports = BranchListView
