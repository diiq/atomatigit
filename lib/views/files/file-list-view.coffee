_      = require 'lodash'
{View} = require 'atom-space-pen-views'

FileView = require './file-view'

# Public: Represents the file list view with an individual list for staged,
#         unstaged and untracked files.
class FileListView extends View
  @content: ->
    @div class: 'file-list-view list-view', tabindex: -1, =>
      @h2 outlet: 'untrackedHeader', 'untracked:'
      @div class: 'untracked', outlet: 'untracked'
      @h2 outlet: 'unstagedHeader', 'unstaged:'
      @div class: 'unstaged', outlet: 'unstaged'
      @h2 outlet: 'stagedHeader', 'staged:'
      @div class: 'staged', outlet: 'staged'

  # Public: Constructor.
  initialize: (@model) ->

  attached: =>
    @model.on 'repaint', @repaint

  # Internal: Prepare removing this view.
  detached: =>
    @model.off 'repaint', @repaint

  # Internal: Trigger repopulation of the untracked file list view.
  repopulateUntracked: =>
    @untracked.empty()
    _.each @model.untracked(), (file) => @untracked.append new FileView(file)

  # Internal: Trigger repopulation of the unstaged file list view.
  repopulateUnstaged: =>
    @unstaged.empty()
    _.each @model.unstaged(), (file) => @unstaged.append new FileView(file)

  # Internal: Trigger repopulation of the staged file list view.
  repopulateStaged: =>
    @staged.empty()
    _.each @model.staged(), (file) => @staged.append new FileView(file)

  # Public: Trigger repainting of all file list views.
  repaint: =>
    @repopulateUntracked()
    @repopulateUnstaged()
    @repopulateStaged()

module.exports = FileListView
