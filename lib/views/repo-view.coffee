$ = require 'jquery'

{View, EditorView} = require 'atom'
{FileListView} = require './files'
{BranchBriefView, BranchListView}  = require './branches'
{CommitListView} = require './commits'
ErrorView = require './error-view'
{git} = require '../git'

module.exports =
class RepoView extends View
  @content: (model) ->
    @div class: 'atomatigit', =>
      @div class: "resize-handle", outlet: "resize_handle"
      @subview "branch_brief_view", new BranchBriefView model.current_branch
      @div class: "input", outlet: "input", =>
        @subview "input_editor", new EditorView(mini: true)

      @ul class: "list-inline tab-bar inset-panel", =>
        @li outlet: "files_tab", class: "tab active", click: "goto_file_view", =>
          @div class: 'title', "Staging"
        @li outlet: "branches_tab", class: "tab", click: "goto_branch_view", =>
          @div class: 'title', "Branches"
        @li outlet: "commits_tab", class: "tab", click: "goto_commit_log", =>
          @div class: 'title', "Log"

      @subview "fileListView", new FileListView model.files
      @subview "branchListView", new BranchListView model.branch_list
      @subview "commit_list_view", new CommitListView model.commit_list
      @subview "error", new ErrorView git

  initialize: (repo) ->
    @model = repo
    #@set_active_view @file_list_view
    @insert_commands()

    @model.on "need_input", @get_input

    @on 'core:confirm', => @complete_input()
    @on 'core:cancel', => @cancel_input()
    @on 'click', => @focus()
    @on 'focusout', => @unfocus()
    @input_editor.on "click", -> false
    @resize_handle.on "mousedown", @resize_started

    atom_git = atom.project.getRepo()
    @subscribe atom_git, 'status-changed', => @model.refresh()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @model.files.next()
    atom.workspaceView.command "atomatigit:previous", => @model.files.previous()
    atom.workspaceView.command "atomatigit:stage", => @model.selection().stage()
    atom.workspaceView.command "atomatigit:unstage", => @model.selection().unstage()
    atom.workspaceView.command "atomatigit:kill", => @model.selection().kill()
    atom.workspaceView.command "atomatigit:open", => @model.selection().open()
    atom.workspaceView.command "atomatigit:toggle-diff", => @model.selection().toggleDiff()
    atom.workspaceView.command "atomatigit:commit", => @model.initiate_commit()
    atom.workspaceView.command "atomatigit:push", => @model.push()
    atom.workspaceView.command "atomatigit:fetch", => @model.fetch()
    atom.workspaceView.command "atomatigit:stash", => @model.stash()
    atom.workspaceView.command "atomatigit:stash_pop", => @model.stash_pop()
    # atom.workspaceView.command "atomatigit:checkout_branch", => @model.selected_branch().checkout()
    # atom.workspaceView.command "atomatigit:reset_to_commit", => @model.selected_commit().reset_to()
    # atom.workspaceView.command "atomatigit:hard_reset_to_commit", => @model.selected_commit().hard_reset_to()
    # atom.workspaceView.command "atomatigit:create_branch", => @model.initiate_create_branch()
    atom.workspaceView.command "atomatigit:git_command", => @model.initiate_git_command()
    atom.workspaceView.command "atomatigit:input:newline", => @input_newline()
    atom.workspaceView.command "atomatigit:input:up", => @input_up()
    atom.workspaceView.command "atomatigit:input:down", => @input_down()
    atom.workspaceView.command "atomatigit:branches", => @goto_branch_view()
    atom.workspaceView.command "atomatigit:files", => @goto_file_view()
    # atom.workspaceView.command "atomatigit:commit_log", => @goto_commit_log()
    atom.workspaceView.command "atomatigit:commit_complete", => @commit_and_close()
    atom.workspaceView.command "atomatigit:refresh", => @refresh()

  commit_and_close: ->
    @model.complete_commit()

  refresh: ->
    @model.refresh()
    git.clearTaskCounter()

  # deactivate_tabs: ->
  #   @commits_tab.removeClass "active"
  #   @files_tab.removeClass "active"
  #   @branches_tab.removeClass "active"

  # goto_branch_view: ->
  #   @deactivate_tabs()
  #   @branches_tab.addClass "active"
  #   @set_active_view @branch_list_view

  # goto_file_view: ->
  #   @deactivate_tabs()
  #   @files_tab.addClass "active"
  #   @set_active_view @file_list_view

  # goto_commit_log: ->
  #   @deactivate_tabs()
  #   @commits_tab.addClass "active"
  #   @set_active_view @commit_list_view

  # set_active_view: (view) ->
  #   @mode_switch_flag = true
  #   @file_list_view.addClass "hidden"
  #   @branch_list_view.addClass "hidden"
  #   @commit_list_view.addClass "hidden"
  #   view.removeClass "hidden"
  #   view.focus()
  #   @active_view = view

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

  focus: ->
    @addClass "focused"
    #@active_view.focus()

  unfocus: ->
    if !@mode_switch_flag
      @removeClass "focused"
    else
      @mode_switch_flag = false

  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
