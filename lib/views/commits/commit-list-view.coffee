{View} = require 'atom'
CommitView = require './commit-view'

class CommitListView extends View
  @content: ->
    @div class: 'commit-list-view list-view', tabindex: -1

  initialize: (@model) ->
    @model.on 'repopulate', @repaint

  beforeRemove: =>
    @model.off 'repopulate', @repaint

  repaint: =>
    @empty()
    for commit in @model.models
      @append new CommitView(commit)

module.exports = CommitListView
