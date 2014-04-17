{View} = require 'atom'
FileView = require './file-view'

module.exports =
class FileListView extends View
  @content: ->
    @div class: "file-list-view list-view", tabindex: -1, =>
      @h2 outlet: "untrackedHeader", "untracked:"
      @div class: "untracked", outlet: "untracked"
      @h2 outlet: "unstagedHeader", "unstaged:"
      @div class: "unstaged", outlet: "unstaged"
      @h2 outlet: "stagedHeader", "staged:"
      @div class: "staged", outlet: "staged"

  initialize: (fileList) ->
    @model = fileList
    @model.on "repopulate", @repopulate

  beforeRemove: ->
    @model.off "repopulate", @repopulate

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
