_      = require 'lodash'
{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

BranchBriefView = require './branch-brief-view'

# Public: Visual representation of the branch list.
class BranchListView extends View
  @content: ->
    @div class: 'branch-list-view list-view', tabindex: -1, =>
      @h2 'local:'
      @div outlet: 'localDom'
      @h2 'remote:'
      @div outlet: 'remoteDom'

  # Public: Constructor.
  initialize: (@model) ->

  # Public: 'attached' hook.
  attached: =>
    @model.on 'repaint', @repaint

  # Public: 'detached' hook.
  detached: =>
    @model.off 'repaint', @repaint

  # Internal: Empty the 'localDom' and 'remoteDom' lists.
  emptyLists: =>
    @localDom.empty()
    @remoteDom.empty()

  # Public: Trigger a repaint.
  repaint: =>
    @emptyLists()
    _.each @model.local(), (branch) => @localDom.append new BranchBriefView(branch)
    _.each @model.remote(), (branch) => @remoteDom.append new BranchBriefView(branch)

module.exports = BranchListView
