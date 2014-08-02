_      = require 'lodash'
{View} = require 'atom'

FileView = require './file-view'

class FileListView extends View
  @content: ->
    @div class: 'file-list-view list-view', tabindex: -1, =>
      @h2 outlet: 'untrackedHeader', 'untracked:'
      @div class: 'untracked', outlet: 'untracked'
      @h2 outlet: 'unstagedHeader', 'unstaged:'
      @div class: 'unstaged', outlet: 'unstaged'
      @h2 outlet: 'stagedHeader', 'staged:'
      @div class: 'staged', outlet: 'staged'

  initialize: (@model) ->
    @model.on 'repaint', @repopulate

  beforeRemove: =>
    @model.off 'repaint', @repopulate

  repopulateUntracked: ->
    @untracked.empty()
    _.each @model.untracked, (file) -> @untracked.append new FileView(file)

  repopulateUnstaged: ->
    @unstaged.empty()
    _.each @model.unstaged(), (file) -> @unstaged.append new FileView(file)

  repopulateStaged: ->
    @staged.empty()
    _.each @model.staged(), (file) -> @staged.append new FileView(file)

  repopulate: =>
    @repopulateUntracked()
    @repopulateUnstaged()
    @repopulateStaged()

module.exports = FileListView
