{View, EditorView} = require 'atom'
FileListView = require './file-list-view'
BranchBriefView = require './branch-brief-view'

module.exports =
class RepoView extends View
  @content: (repo) ->
    @div class: 'atomatigit', =>
      @subview "branch_brief_view", new BranchBriefView repo.current_branch
      #@textarea class: "block-input", outlet: "block_input"
      #@input class: "line-input", outlet: "block_input"
      @subview "block_input", new EditorView(mini: true)
      @subview "file_list_view", new FileListView repo.file_list

  initialize: (repo) ->
    @repo = repo
    @block_input.addClass "block-input"
    @insert_commands()
    @repo.on "need_message", @get_message
    @on 'core:confirm', => @finish_commit()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @repo.file_list.next()
    atom.workspaceView.command "atomatigit:previous", => @repo.file_list.previous()
    atom.workspaceView.command "atomatigit:stage", => @repo.stage()
    atom.workspaceView.command "atomatigit:open", => @repo.open()
    atom.workspaceView.command "atomatigit:toggle_file_diff", => @repo.toggle_file_diff()
    atom.workspaceView.command "atomatigit:cancel_commit", => @cancel_commit()
    atom.workspaceView.command "atomatigit:commit", => @repo.initiate_commit()

  get_message: =>
    @block_input.setText "goo"
    @block_input.addClass "active"
    @block_input.focus()

  finish_commit: ->
    @block_input.removeClass "active"
    @repo.finish_commit @block_input.getText()

  focus: ->
    @file_list_view.focus()

  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
