$                                 = require 'jquery'
{View, EditorView}                = require 'atom'

git                                  = require '../git'
{FileListView}                       = require './files'
{CurrentBranchView, BranchListView}  = require './branches'
{CommitListView}                     = require './commits'
ErrorView                            = require './error-view'

# Public: RepoView class that extends the {View} prototype.
class RepoView extends View
  @content: (model) ->
    @div class: 'atomatigit', =>
      @div class: 'resize-handle', outlet: 'resizeHandle'
      @subview 'currentBranchView', new CurrentBranchView(model.currentBranch)
#      @subview 'error', new ErrorView git
      @div class: 'input', outlet: 'input', =>
        @subview 'inputEditor', new EditorView(mini: true)

      @ul class: 'list-inline tab-bar inset-panel', =>
        @li outlet: 'fileTab', class: 'tab active', click: 'showFiles', =>
          @div class: 'title', 'Staging'
        @li outlet: 'branchTab', class: 'tab', click: 'showBranches', =>
          @div class: 'title', 'Branches'
        @li outlet: 'commitTab', class: 'tab', click: 'showCommits', =>
          @div class: 'title', 'Log'

      @div class: 'lists', =>
        @subview 'fileListView', new FileListView model.fileList
        @subview 'branchListView', new BranchListView model.branchList
        @subview 'commitListView', new CommitListView model.commitList

  initialize: (@model) ->
    @insertCommands()
    @model.on 'needInput', @getInput

    @on 'core:confirm', => @completeInput()
    @on 'core:cancel', => @cancelInput()
    @on 'click', => @focus()
    @on 'focusout', => @unfocus()
    @inputEditor.on 'click', -> false
    @resizeHandle.on 'mousedown', @resizeStarted

    atomGit = atom.project.getRepo()
    @subscribe(atomGit, 'status-changed', @model.reload) if atomGit?

    @showFiles()

  insertCommands: ->
    atom.workspaceView.command 'atomatigit:next',                 => @model.activeList.next()
    atom.workspaceView.command 'atomatigit:previous',             => @model.activeList.previous()
    atom.workspaceView.command 'atomatigit:stage',                => @model.leaf().stage()
    atom.workspaceView.command 'atomatigit:unstage',              => @model.leaf().unstage()
    atom.workspaceView.command 'atomatigit:kill',                 => @model.leaf().kill()
    atom.workspaceView.command 'atomatigit:open',                 => @model.selection().open()
    atom.workspaceView.command 'atomatigit:toggle-diff',          => @model.selection().toggleDiff()
    atom.workspaceView.command 'atomatigit:commit',               => @model.initiateCommit()
    atom.workspaceView.command 'atomatigit:complete-commit',      => @commitAndClose()
    atom.workspaceView.command 'atomatigit:push',                 => @model.push()
    atom.workspaceView.command 'atomatigit:fetch',                => @model.fetch()
    atom.workspaceView.command 'atomatigit:stash',                => @model.stash()
    atom.workspaceView.command 'atomatigit:stash-pop',            => @model.stashPop()
    atom.workspaceView.command 'atomatigit:hard-reset-to-commit', => @model.selection().confirmHardReset()
    atom.workspaceView.command 'atomatigit:create-branch',        => @model.initiateCreateBranch()
    atom.workspaceView.command 'atomatigit:git-command',          => @model.initiateGitCommand()
    atom.workspaceView.command 'atomatigit:input:newline',        => @inputNewline()
    atom.workspaceView.command 'atomatigit:input:up',             => @inputUp()
    atom.workspaceView.command 'atomatigit:input:down',           => @inputDown()
    atom.workspaceView.command 'atomatigit:branches',             => @showBranches()
    atom.workspaceView.command 'atomatigit:files',                => @showFiles()
    atom.workspaceView.command 'atomatigit:commit-log',           => @showCommits()
    atom.workspaceView.command 'atomatigit:refresh',              => @refresh()

  commitAndClose: ->
    atom.workspaceView.trigger('core:save')
    atom.workspaceView.trigger('core:close')
    @model.completeCommit()
    @focus()

  refresh: ->
    @model.reload()

  showBranches: ->
    @model.activeList = @model.branchList
    @activeView = @branchListView
    @showViews()

  showFiles: ->
    @model.activeList = @model.fileList
    @activeView = @fileListView
    @showViews()

  showCommits: ->
    @model.activeList = @model.commitList
    @activeView = @commitListView
    @showViews()

  showViews: ->
    @modeSwitchFlag = true
    @fileListView.toggleClass 'hidden', @activeView != @fileListView
    @fileTab.toggleClass 'active', @activeView == @fileListView

    @branchListView.toggleClass 'hidden', @activeView != @branchListView
    @branchTab.toggleClass 'active', @activeView == @branchListView

    @commitListView.toggleClass 'hidden', @activeView != @commitListView
    @commitTab.toggleClass 'active', @activeView == @commitListView

  resizeStarted: ->
    $(document.body).on 'mousemove', @resize
    $(document.body).on 'mouseup', @resizeStopped

  resizeStopped: ->
    $(document.body).off 'mousemove', @resize
    $(document.body).off 'mouseup', @resizeStopped

  resize: ({pageX}) ->
    width = $(document.body).width() - pageX
    @width(width)

  getInput: (options) ->
    @input.removeClass 'block'
    extraQuery = ''
    if options.block
      @input.addClass 'block'
      extraQuery = ' (shift+enter to finish)'

    @inputCallback = options.callback
    @inputEditor.setPlaceholderText options.query + extraQuery
    @inputEditor.setText ''
    @input.show 100, =>
      @inputEditor.redraw()
      @inputEditor.focus()
      #@inputEditor.on 'focusout', @cancelInput

  completeInput: ->
    @input.hide()
    @inputCallback @inputEditor.getText()
    @modeSwitchFlag = true
    @focus()

  cancelInput: ->
    @input.hide()
    @inputCallback = null
    @modeSwitchFlag = true
    @inputEditor.off 'focusout', @cancelInput
    @focus()

  focus: ->
    @addClass 'focused'
    @activeView.focus()

  unfocus: ->
    if !@modeSwitchFlag
      @removeClass 'focused'
    else
      @focus()
      @modeSwitchFlag = false

  # Tear down any state and detach
  destroy: ->
    @detach()

module.exports = RepoView
