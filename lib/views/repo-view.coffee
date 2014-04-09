{View, EditorView} = require 'atom'
FileListView = require './file-list-view'
BranchBriefView = require './branch-brief-view'
BranchListView = require './branch-list-view'
CommitListView = require './commit-list-view'
_ = require 'underscore'
$ = require 'jquery'
ErrorView = require './error-view'
error_model = require '../error-model'

module.exports =
class RepoView extends View
  @content: (repo) ->
    @div class: 'atomatigit', =>
      @div class: "resize-handle", outlet: "resize_handle"
      @subview "branch_brief_view", new BranchBriefView repo.current_branch
      @div class: "input", outlet: "input", =>
        @subview "input_editor", new EditorView(mini: true)

      @ul class: "list-inline tab-bar inset-panel", =>
        @li outlet: "files_tab", class: "tab active", click: "goto_file_view", =>
          @div class: 'title', "Staging"
        @li outlet: "branches_tab", class: "tab", click: "goto_branch_view", =>
          @div class: 'title', "Branches"
        @li outlet: "commits_tab", class: "tab", click: "goto_commit_log", =>
          @div class: 'title', "Log"

      @subview "file_list_view", new FileListView repo.file_list
      @subview "branch_list_view", new BranchListView repo.branch_list
      @subview "commit_list_view", new CommitListView repo.commit_list
      @subview "error", new ErrorView error_model

  initialize: (repo) ->
    @repo = repo
    @set_active_view @file_list_view
    @insert_commands()

    @repo.on "need_input", @get_input

    @on 'core:confirm', => @complete_input()
    @on 'core:cancel', => @cancel_input()
    @on 'click', => @focus()
    @on 'focusout', => @unfocus()
    @input_editor.on "click", -> false
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
    atom.workspaceView.command "atomatigit:toggle_file_diff", => @repo.selected_file().toggle_diff()
    atom.workspaceView.command "atomatigit:commit", => @repo.initiate_commit()
    atom.workspaceView.command "atomatigit:push", => @repo.push()
    atom.workspaceView.command "atomatigit:fetch", => @repo.fetch()
    atom.workspaceView.command "atomatigit:stash", => @repo.stash()
    atom.workspaceView.command "atomatigit:stash_pop", => @repo.stash_pop()
    atom.workspaceView.command "atomatigit:checkout_branch", => @repo.selected_branch().checkout()
    atom.workspaceView.command "atomatigit:reset_to_commit", => @repo.selected_commit().reset_to()
    atom.workspaceView.command "atomatigit:hard_reset_to_commit", => @repo.selected_commit().hard_reset_to()
    atom.workspaceView.command "atomatigit:create_branch", => @repo.initiate_create_branch()
    atom.workspaceView.command "atomatigit:git_command", => @repo.initiate_git_command()
    atom.workspaceView.command "atomatigit:input:newline", => @input_newline()
    atom.workspaceView.command "atomatigit:input:up", => @input_up()
    atom.workspaceView.command "atomatigit:input:down", => @input_down()
    atom.workspaceView.command "atomatigit:branches", => @goto_branch_view()
    atom.workspaceView.command "atomatigit:files", => @goto_file_view()
    atom.workspaceView.command "atomatigit:commit_log", => @goto_commit_log()
    atom.workspaceView.command "atomatigit:commit_complete", => @commit_and_close()
    atom.workspaceView.command "atomatigit:refresh", => @refresh()

  commit_and_close: ->
    @repo.complete_commit()

  refresh: ->
    @repo.refresh()
    error_model.clear_task_counter()

  deactivate_tabs: ->
    @commits_tab.removeClass "active"
    @files_tab.removeClass "active"
    @branches_tab.removeClass "active"

  goto_branch_view: ->
    @deactivate_tabs()
    @branches_tab.addClass "active"
    @set_active_view @branch_list_view

  goto_file_view: ->
    @deactivate_tabs()
    @files_tab.addClass "active"
    @set_active_view @file_list_view

  goto_commit_log: ->
    @deactivate_tabs()
    @commits_tab.addClass "active"
    @set_active_view @commit_list_view

  set_active_view: (view) ->
    @mode_switch_flag = true
    @file_list_view.addClass "hidden"
    @branch_list_view.addClass "hidden"
    @commit_list_view.addClass "hidden"
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

  get_input: (options) =>
    @input.removeClass "block"
    extra_query = ""
    if options.block
      @input.addClass "block"
      extra_query = " (shift+enter to finish)"

    @input_callback = options.callback
    @input_editor.setPlaceholderText options.query + extra_query
    @input_editor.setText ""
    @input.show 100, () =>
      @input_editor.redraw()
      @input_editor.focus()
      #@input_editor.on 'focusout', @cancel_input

  complete_input: ->
    @input.hide()
    @input_callback @input_editor.getText()
    @mode_switch_flag = true
    @focus()

  cancel_input: =>
    @input.hide()
    @input_callback = null
    @mode_switch_flag = true
    @input_editor.off 'focusout', @cancel_input
    @focus()

  input_newline: ->
    text = @input_editor.getText()
    @input_editor.setText text + "\n"

  input_up: ->
    ed = @input_editor.getEditor()
    ed.moveCursorUp 1

  input_down: ->
    ed = @input_editor.getEditor()
    ed.moveCursorDown 1

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
