{View, EditorView} = require 'atom'
FileListView = require './file-list-view'
BranchBriefView = require './branch-brief-view'
BranchListView = require './branch-list-view'
_ = require 'underscore'
$ = require 'jquery'

module.exports =
class RepoView extends View
  @content: (repo) ->
    @div class: 'atomatigit', =>
      @subview "branch_brief_view", new BranchBriefView repo.current_branch
      #@textarea class: "block-input editor", outlet: "block_input"
      #@input class: "line-input", outlet: "block_input"
      @div class: "resize-handle", outlet: "resize_handle"
      @div class: "block-input", outlet: "block_input", =>
        @div class: "query", outlet: "block_input_query"
        @subview "block_input_editor", new EditorView(mini: true)
      @subview "file_list_view", new FileListView repo.file_list
      @subview "branch_list_view", new BranchListView repo.branch_list

  initialize: (repo) ->
    @repo = repo
    @set_active_view @file_list_view
    @insert_commands()

    @repo.on "need_input", @get_input

    @on 'core:confirm', => @complete_input()
    @on 'core:cancel', => @cancel_input()
    @on 'click', => @focus()
    @on 'focusout', => @unfocus()
    @resize_handle.on "mousedown", @resize_started

    atom_git = atom.project.getRepo()
    @subscribe atom_git, 'status-changed', => @repo.refresh()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @active_view.model.next()
    atom.workspaceView.command "atomatigit:previous", => @active_view.model.previous()
    atom.workspaceView.command "atomatigit:stage", => @repo.selected_file().stage()
    atom.workspaceView.command "atomatigit:unstage", => @repo.selected_file().unstage()
    atom.workspaceView.command "atomatigit:kill_file", => @repo.selected_file().kill()
    atom.workspaceView.command "atomatigit:kill_branch", => @repo.selected_branch().kill()
    atom.workspaceView.command "atomatigit:open", => @repo.selected_file().open()
    atom.workspaceView.command "atomatigit:toggle_file_diff", => @repo.toggle_file_diff()
    atom.workspaceView.command "atomatigit:commit", => @repo.initiate_commit()
    atom.workspaceView.command "atomatigit:push", => @repo.push()
    atom.workspaceView.command "atomatigit:fetch", => @repo.fetch()
    atom.workspaceView.command "atomatigit:stash", => @repo.stash()
    atom.workspaceView.command "atomatigit:stash_pop", => @repo.stash_pop()
    atom.workspaceView.command "atomatigit:checkout_branch", => @repo.checkout_branch()
    atom.workspaceView.command "atomatigit:create_branch", => @repo.initiate_create_branch()
    atom.workspaceView.command "atomatigit:branches", => @set_active_view @branch_list_view
    atom.workspaceView.command "atomatigit:files", => @set_active_view @file_list_view
    atom.workspaceView.command "atomatigit:git_command", => @repo.initiate_git_command()

  set_active_view: (view) ->
    @mode_switch_flag = true
    @file_list_view.addClass "hidden"
    @branch_list_view.addClass "hidden"
    view.removeClass "hidden"
    view.focus()
    @active_view = view

  resize_started: =>
    $(document.body).on 'mousemove', @resize
    $(document.body).on 'mouseup', @resize_stopped

  resize_stopped: =>
    $(document.body).off 'mousemove', @resize
    $(document.body).off 'mouseup', @resize_stopped

  resize: ({pageX}) =>
    width = $(document.body).width() - pageX
    @width(width)

  get_input: (query, callback) =>
    @input_callback = callback
    @block_input.show 100, () =>
      @block_input_query.html query
      @block_input_editor.redraw()
      @block_input_editor.setText ""
      @block_input_editor.focus()

  complete_input: ->
    @block_input.hide()
    @input_callback @block_input_editor.getText()
    @mode_switch_flag = true
    @focus()

  cancel_input: ->
    @block_input.hide()
    @input_callback = null
    @mode_switch_flag = true
    @focus()

  focus: ->
    @addClass "focused"
    @active_view.focus()

  unfocus: ->
    if !@mode_switch_flag
      @removeClass "focused"
    else
      @mode_switch_flag = false

  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
