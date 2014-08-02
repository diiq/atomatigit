{View} = require 'atom'
DiffView = require '../diffs/diff-view'

class FileView extends View
  @content: (file) ->
    @div class: 'file', mousedown: 'clicked', =>
      @div class: 'filename', "#{file.path()}"

  initialize: (@model) ->
    @model.on 'change:selected', @showSelection
    @model.on 'change:diff', @showDiff
    @showSelection()
    @showDiff()

  beforeRemove: =>
    @model.off 'change:selected', @showSelection
    @model.off 'change:diff', @showDiff

  clicked: =>
    @model.selfSelect()

  showSelection: =>
    @toggleClass 'selected', @model.isSelected()

  showDiff: =>
    @find('.diff').remove()
    if @model.showDiffP()
      @append new DiffView @model.diff()

module.exports = FileView
