_      = require 'lodash'
{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

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
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add @element,
      'atomatigit:showCommit': => @model.selection()?.showCommit?()
      'atomatigit:hard-reset-to-commit': =>
        @model.selection()?.confirmHardReset()

  # Public: 'detached' hook.
  detached: =>
    @model.off 'repaint', @repaint
    @subscriptions.dispose()

  # Public: Trigger a repaint.
  repaint: =>
    @empty()
    _.each @model.models, (commit) => @append new CommitView(commit)

module.exports = CommitListView
