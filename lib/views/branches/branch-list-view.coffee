_      = require 'lodash'
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
    @model.on 'repaint', @repaint

  beforeRemove: =>
    @model.off 'repaint', @repaint

  emptyLists: =>
    @localDom.empty()
    @remoteDom.empty()

  repaint: =>
    @emptyLists()

    _.each @model.local(), (branch) => @localDom.append new BranchBriefView(branch)
    _.each @model.remote(), (branch) => @remoteDom.append new BranchBriefView(branch)

module.exports = BranchListView
