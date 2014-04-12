{View} = require 'atom'
FileView = require './file-view'

module.exports =
class FileListView extends View
  @content: ->
    @div class: "file-list-view list-view", tabindex: -1, =>
      @h2 outlet: "untrackedHeader", "untracked:"
      @div outlet: "untracked"
      @h2 outlet: "unstagedHeader", "unstaged:"
      @div outlet: "unstaged"
      @h2 outlet: "stagedHeader", "staged:"
      @div outlet: "staged"

  initialize: (fileList) ->
    @model = fileList
    @model.on "change", @repopulate

  beforeRemove: ->
    @model.off "change", @repopulate

  repopulateUntracked: ->
    @untracked.empty()

    for file in @model.untracked()
      @untracked.append new FileView file

  repopulateUnstaged: ->
    @unstaged.empty()

    for file in @model.unstaged()
      @unstaged.append new FileView file

  repopulateStaged: ->
    @staged.empty()

    for file in @model.staged()
      @staged.append new FileView file

  repopulate: =>
    @repopulateUntracked()
    @repopulateUnstaged()
    @repopulateStaged()
