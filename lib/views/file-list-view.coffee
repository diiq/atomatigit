{View} = require 'atom'
FileView = require './file-view'

module.exports =
class FileListView extends View
  @content: ->
    @div class: "file-list-view list-view", tabindex: -1, =>
      @h2 "untracked:"
      @div outlet: "untracked_dom"
      @h2 "unstaged:"
      @div outlet: "unstaged_dom"
      @h2 "staged:"
      @div outlet: "staged_dom"

  initialize: (file_list) ->
    @model = file_list
    @model.on "refresh", @repaint

  beforeRemove: ->
    @model.off "refresh", @repaint

  empty_lists: ->
    @untracked_dom.empty()
    @unstaged_dom.empty()
    @staged_dom.empty()

  repaint: =>
    @empty_lists()

    for file in @model.untracked()
      @untracked_dom.append new FileView file

    for file in @model.unstaged()
      @unstaged_dom.append new FileView file

    for file in @model.staged()
      @staged_dom.append new FileView file
