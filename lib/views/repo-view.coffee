{$, View, EditorView} = require 'atom'

{FileListView}                       = require './files'
{CurrentBranchView, BranchListView}  = require './branches'
{CommitListView}                     = require './commits'
ErrorView                            = require './error-view'
InputView                            = require './input-view'

# Public: RepoView class that extends the {View} prototype.
class RepoView extends View
  @content: (model) ->
    @div class: 'atomatigit', =>
      @div class: 'resize-handle', outlet: 'resizeHandle'
      @subview 'currentBranchView', new CurrentBranchView(model.currentBranch)

      @ul class: 'list-inline tab-bar inset-panel', =>
        @li outlet: 'fileTab', class: 'tab active', click: 'showFiles', =>
          @div class: 'title', 'Files'
        @li outlet: 'branchTab', class: 'tab', click: 'showBranches', =>
          @div class: 'title', 'Branches'
        @li outlet: 'commitTab', class: 'tab', click: 'showCommits', =>
          @div class: 'title', 'Log'

      @div class: 'lists', =>
        @subview 'fileListView', new FileListView(model.fileList)
        @subview 'branchListView', new BranchListView(model.branchList)
        @subview 'commitListView', new CommitListView(model.commitList)

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'needInput', @getInput

    @on 'click', @focus
    $(document.body).on 'click', @unfocusIfNotClicked
      .on 'keyup', @unfocusIfNotActive
    @resizeHandle.on 'mousedown', @resizeStarted

    atomGit = atom.project.getRepo()
    @subscribe(atomGit, 'status-changed', @model.reload) if atomGit?

    @insertCommands()
    @model.reload().then @showFiles

  # Internal: Register atomatigit commands with atom.
  insertCommands: =>
    atom.workspaceView.command 'atomatigit:next', => @model.activeList.next()
    atom.workspaceView.command 'atomatigit:previous', => @model.activeList.previous()

    atom.workspaceView.command 'atomatigit:files', @showFiles
    atom.workspaceView.command 'atomatigit:branches', @showBranches
    atom.workspaceView.command 'atomatigit:commit-log', @showCommits

    atom.workspaceView.command 'atomatigit:commit', =>
      @model.initiateCommit()
      @unfocus()
    atom.workspaceView.command 'atomatigit:git-command', =>
      @model.initiateGitCommand()
      @unfocus()

    atom.workspaceView.command 'atomatigit:input:down', @inputDown
    atom.workspaceView.command 'atomatigit:input:newline', @inputNewline
    atom.workspaceView.command 'atomatigit:input:up', @inputUp

    atom.workspaceView.command 'atomatigit:stage', => @model.leaf()?.stage()
    atom.workspaceView.command 'atomatigit:stash', @model.stash
    atom.workspaceView.command 'atomatigit:stash-pop', @model.stashPop
    atom.workspaceView.command 'atomatigit:toggle-diff', => @model.selection()?.toggleDiff()
    atom.workspaceView.command 'atomatigit:unstage', => @model.leaf()?.unstage()
    atom.workspaceView.command 'atomatigit:hard-reset-to-commit', => @model.selection()?.confirmHardReset()

    atom.workspaceView.command 'atomatigit:create-branch', @model.initiateCreateBranch
    atom.workspaceView.command 'atomatigit:fetch', @model.fetch
    atom.workspaceView.command 'atomatigit:kill', => @model.leaf()?.kill()
    atom.workspaceView.command 'atomatigit:open', => @model.selection()?.open()
    atom.workspaceView.command 'atomatigit:push', @model.push
    atom.workspaceView.command 'atomatigit:refresh', @refresh
    atom.workspaceView.command 'atomatigit:showCommit', => @model.selection()?.showCommit?()

    atom.workspaceView.command 'atomatigit:focus', @focus
    atom.workspaceView.command 'atomatigit:unfocus', @unfocus
    atom.workspaceView.command 'atomatigit:toggle-focus', @toggleFocus

  # Public: Force a full refresh.
  refresh: =>
    @model.reload().then => @activeView.repaint()
    @focus()

  # Public: Show the 'branches' tab.
  showBranches: =>
    @model.activeList = @model.branchList
    @activeView = @branchListView
    @activateView()

  # Public: Show the 'files' tab.
  showFiles: =>
    @model.activeList = @model.fileList
    @activeView = @fileListView
    @activateView()

  # Public: Show the 'commits' tab.
  showCommits: =>
    @model.activeList = @model.commitList
    @activeView = @commitListView
    @activateView()

  # Internal: Toggle the visibility of the selected view.
  activateView: =>
    @fileListView.toggleClass 'hidden', @activeView != @fileListView
    @fileTab.toggleClass 'active', @activeView == @fileListView

    @branchListView.toggleClass 'hidden', @activeView != @branchListView
    @branchTab.toggleClass 'active', @activeView == @branchListView

    @commitListView.toggleClass 'hidden', @activeView != @commitListView
    @commitTab.toggleClass 'active', @activeView == @commitListView

    @focus()

  # Internal: Handler for 'resizeStarted'.
  resizeStarted: =>
    $(document.body).on 'mousemove', @resize
    $(document.body).on 'mouseup', @resizeStopped

  # Internal: Handler for 'resizeStopped'.
  resizeStopped: =>
    $(document.body).off 'mousemove', @resize
    $(document.body).off 'mouseup', @resizeStopped

  # Internal: Resize the width.
  #   object.pageX: The width to resize atomatigit to.
  resize: ({pageX}) =>
    width = $(document.body).width() - pageX
    @width(width)

  # Public: Request user input.
  #   options - The options as {Object}.
  getInput: (options) ->
    new InputView(options)

  # Internal: Checks if the atomatigit pane has focus.
  hasFocus: =>
    @activeView?.is(':focus') or document.activeElement is @activeView

  # Internal: Determine if the atomatigit pane was clicked. If not, remove focus.
  unfocusIfNotClicked: (e) =>
    return @unfocus() unless e.target.matches '.atomatigit, .atomatigit *'

  # Internal: Unfocus when losing focus by keyboard.
  unfocusIfNotActive: (e) =>
    return @unfocus() unless @hasFocus()

  # Public: Focus the atomatigit pane.
  focus: =>
    @activeView?.focus?() and @addClass 'focused'

  # Public: Unfocus the atomatigit pane.
  unfocus: =>
    @removeClass 'focused'

  # Public: Toggle the focus on the atomatigit pane.
  toggleFocus: =>
    return @focus() unless @hasFocus()
    @unfocus()
    atom.workspace.getActivePane().activate()

  # Public: Destructor.
  destroy: =>
    @detach()

module.exports = RepoView
