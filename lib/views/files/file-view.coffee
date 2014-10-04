{$$, View} = require 'atom'
DiffView = require '../diffs/diff-view'

# Public: Visual representation of a file.
class FileView extends View
  @content: (file) ->
    @div class: 'file', mousedown: 'clicked', =>
      @span class: 'mode', file.getMode()
      @span class: 'path', file.path()

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    @model.on 'change:diff', @showDiff
    @showSelection()
    @showDiff()

  # Public: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'change:selected', @showSelection
    @model.off 'change:diff', @showDiff

  # Public: 'clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Public: Show the selection.
  showSelection: =>
    @toggleClass 'selected', @model.isSelected()

  # Public: Show the file diff if there is any.
  showDiff: =>
    @find('.diff').remove()
    @append new DiffView(@model.diff()) if @model.showDiffP()

module.exports = FileView
