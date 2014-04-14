{View} = require 'atom'
CommitView = require './commit-view'

module.exports =
class CommitListView extends View
  @content: ->
    @div class: "commit-list-view list-view", tabindex: -1

  initialize: (commit_list) ->
    @model = commit_list
    @model.on "repopulate", @repaint

  beforeRemove: ->
    @model.off "repopulate", @repaint

  repaint: =>
    @empty()
    for commit in @model.models
      @append new CommitView commit
