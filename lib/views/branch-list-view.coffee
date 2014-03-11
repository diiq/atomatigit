{View} = require 'atom'
BranchView = require './branch-view'

module.exports =
class BranchListView extends View
  @content: ->
    @div class: "branch-list-view", tabindex: -1, =>
      @h2 "local:"
      @div outlet: "local_dom"
      @h2 "remote:"
      @div outlet: "remote_dom"


  initialize: (file_list) ->
    @file_list = file_list
    @file_list.on "refresh", @repaint

  beforeRemove: ->
    @file_list.off "refresh", @repaint

  empty_lists: ->
    @untracked_dom.empty()
    @unstaged_dom.empty()
    @staged_dom.empty()

  repaint: =>
    @empty_lists()

    for file in @file_list.untracked()
      @untracked_dom.append new FileView file

    for file in @file_list.unstaged()
      @unstaged_dom.append new FileView file

    for file in @file_list.staged()
      @staged_dom.append new FileView file
