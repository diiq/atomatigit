_      = require 'lodash'
{View} = require 'atom-space-pen-views'

CommitView = require './commit-view'

# Public: Visual representation of the commit list.
class CommitListView extends View
  @content: ->
    @div class: 'commit-list-view list-view', tabindex: -1

  # Public: Constructor.
  initialize: (@model) ->

  # Public: 'attached' hook.
  attached: =>
    @model.on 'repaint', @repaint

  # Public: 'detached' hook.
  detached: =>
    @model.off 'repaint', @repaint

  # Public: Trigger a repaint.
  repaint: =>
    @empty()
    _.each @model.models, (commit) => @append new CommitView(commit)

module.exports = CommitListView
