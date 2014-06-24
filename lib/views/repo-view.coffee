$ = require 'jquery'

{View, EditorView} = require 'atom'
{FileListView} = require './files'
{CurrentBranchView, BranchListView}  = require './branches'
{CommitListView} = require './commits'
ErrorView = require './error-view'
{git} = require '../git'

module.exports =
class RepoView extends View
  @content: (model) ->
    @div class: 'atomatigit', =>
      @div class: "resize-handle", outlet: "resize_handle"
      @subview "current_branch_view", new CurrentBranchView model.current_branch
      @subview "error", new ErrorView git
      @div class: "input", outlet: "input", =>
        @subview "input_editor", new EditorView(mini: true)

      @ul class: "list-inline tab-bar inset-panel", =>
        @li outlet: "file_tab", class: "tab active", click: "showFiles", =>
          @div class: 'title', "Staging"
        @li outlet: "branch_tab", class: "tab", click: "showBranches", =>
          @div class: 'title', "Branches"
        @li outlet: "commit_tab", class: "tab", click: "showCommits", =>
          @div class: 'title', "Log"

      @div class: "lists", =>
        @subview "file_list_view", new FileListView model.file_list
        @subview "branch_list_view", new BranchListView model.branch_list
        @subview "commit_list_view", new CommitListView model.commit_list

  initialize: (repo) ->
    @model = repo

    @insert_commands()

    @model.on "need_input", @get_input

    @on 'core:confirm', => @complete_input()
    @on 'core:cancel', => @cancel_input()
    @on 'click', => @focus()
    @on 'focusout', => @unfocus()
    @input_editor.on "click", -> false
    @resize_handle.on "mousedown", @resize_started

    atom_git = atom.project.getRepo()
    @subscribe atom_git, 'status-changed', @model.reload

    @showFiles()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:next", => @model.active_list.next()
    atom.workspaceView.command "atomatigit:previous", => @model.active_list.previous()
    atom.workspaceView.command "atomatigit:stage", => @model.leaf().stage()
    atom.workspaceView.command "atomatigit:unstage", => @model.leaf().unstage()
    atom.workspaceView.command "atomatigit:kill", => @model.leaf().kill()
    atom.workspaceView.command "atomatigit:open", => @model.selection().open()
    atom.workspaceView.command "atomatigit:toggle-diff", => @model.selection().toggleDiff()
    atom.workspaceView.command "atomatigit:commit", => @model.initiateCommit()
    atom.workspaceView.command "atomatigit:complete-commit", => @commitAndClose()
    atom.workspaceView.command "atomatigit:push", => @model.push()
    atom.workspaceView.command "atomatigit:fetch", => @model.fetch()
    atom.workspaceView.command "atomatigit:stash", => @model.stash()
    atom.workspaceView.command "atomatigit:stash-pop", => @model.stashPop()
    atom.workspaceView.command "atomatigit:hard-reset-to-commit", => @model.selection().confirmHardReset()
    atom.workspaceView.command "atomatigit:showCommit", => @model.selection().showCommit()
    atom.workspaceView.command "atomatigit:create-branch", => @model.initiateCreateBranch()
    atom.workspaceView.command "atomatigit:git-command", => @model.initiateGitCommand()
    atom.workspaceView.command "atomatigit:input:newline", => @input_newline()
    atom.workspaceView.command "atomatigit:input:up", => @input_up()
    atom.workspaceView.command "atomatigit:input:down", => @input_down()
    atom.workspaceView.command "atomatigit:branches", => @showBranches()
    atom.workspaceView.command "atomatigit:files", => @showFiles()
    atom.workspaceView.command "atomatigit:commit-log", => @showCommits()
    atom.workspaceView.command "atomatigit:refresh", => @refresh()

  commitAndClose: ->
    atom.workspaceView.trigger("core:save")
    atom.workspaceView.trigger("core:close")
    @model.completeCommit()
    @focus()

  refresh: ->
    @model.reload()
    git.clearTaskCounter()

  showBranches: ->
    @model.active_list = @model.branch_list
    @active_view = @branch_list_view
    @showViews()

  showFiles: ->
    @model.active_list = @model.file_list
    @active_view = @file_list_view
    @showViews()

  showCommits: ->
    @model.active_list = @model.commit_list
    @active_view = @commit_list_view
    @showViews()

  showViews: ->
    @mode_switch_flag = true
    @file_list_view.toggleClass "hidden", @active_view != @file_list_view
    @file_tab.toggleClass "active", @active_view == @file_list_view

    @branch_list_view.toggleClass "hidden", @active_view != @branch_list_view
    @branch_tab.toggleClass "active", @active_view == @branch_list_view

    @commit_list_view.toggleClass "hidden", @active_view != @commit_list_view
    @commit_tab.toggleClass "active", @active_view == @commit_list_view

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
    @active_view.focus()

  unfocus: ->
    if !@mode_switch_flag
      @removeClass "focused"
    else
      @focus()
      @mode_switch_flag = false

  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
