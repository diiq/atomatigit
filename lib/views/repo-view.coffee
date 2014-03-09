{View} = require 'atom'
FileListView = require './file-list-view'
BranchBriefView = require './branch-brief-view'

module.exports =
class RepoView extends View
  @content: (repo) ->
    @div class: 'atomatigit', =>
      @subview "branch_brief_view", new BranchBriefView repo.current_branch
      @subview "file_list_view", new FileListView repo.file_list

  initialize: (repo) ->
    @repo = repo
    @insert_commands()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @repo.file_list.next()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
