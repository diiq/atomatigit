_      = require 'lodash'
{View} = require 'atom'

CommitView = require './commit-view'

# Public: Visual representation of the commit list.
class CommitListView extends View
  @content: ->
    @div class: 'commit-list-view list-view', tabindex: -1

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'repaint', @repaint

  # Public: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'repaint', @repaint

  # Public: Trigger a repaint.
  repaint: =>
    @empty()
    _.each @model.models, (commit) => @append new CommitView(commit)

module.exports = CommitListView
