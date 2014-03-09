{View} = require 'atom'
FileListView = require './file-list-view'
BranchBriefView = require './branch-brief-view'

module.exports =
class RepoView extends View
  @content: (repo) ->
    @div class: 'atomatigit', =>
      @subview "file_list_view", new FileListView repo.file_list
#      @subview "branch_brief_view", new BranchBriefView

  initialize: (repo) ->
    @repo = repo
    console.log @file_list_view
    @insert_commands()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @repo.file_list.next()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
