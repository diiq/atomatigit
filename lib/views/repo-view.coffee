{$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

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
      @subview 'currentBranchView', new CurrentBranchView(model)

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
    @InitPromise = @model.reload().then @showFiles

  # Public: 'attached' hook.
  attached: =>
    @model.on 'needInput', @getInput
    @model.on 'complete', @focus
    @model.on 'update', @refresh
    @on 'click', @focus
    @resizeHandle.on 'mousedown', @resizeStarted

    @fileListView.on 'blur', @unfocusIfNotActive
    @branchListView.on 'blur', @unfocusIfNotActive
    @commitListView.on 'blur', @unfocusIfNotActive

    @subscriptions = new CompositeDisposable
    @subscriptions.add(@insertCommands())

  # Internal: 'detached' handler.
  detached: =>
    @model.off 'needInput', @getInput
    @model.off 'complete', @focus
    @model.off 'update', @refresh
    @off 'click', @focus
    @resizeHandle.off 'mousedown', @resizeStarted

    @fileListView.off 'blur', @unfocusIfNotActive
    @branchListView.off 'blur', @unfocusIfNotActive
    @commitListView.off 'blur', @unfocusIfNotActive

    @subscriptions.dispose()

  # Internal: Register atomatigit commands with atom.
  insertCommands: =>
    atom.commands.add @element,
      'core:move-down': => @model.activeList.next()
      'core:move-up': => @model.activeList.previous()
      'core:cancel': @hide
      'atomatigit:files': @showFiles
      'atomatigit:branches': @showBranches
      'atomatigit:commit-log': @showCommits
      'atomatigit:commit': =>
        @model.initiateCommit()
        @unfocus()
      'atomatigit:git-command': =>
        @model.initiateGitCommand()
        @unfocus()
      'atomatigit:stage': => @model.leaf()?.stage()
      'atomatigit:stash': @model.stash
      'atomatigit:stash-pop': @model.stashPop
      'atomatigit:toggle-diff': => @model.selection()?.toggleDiff()
      'atomatigit:unstage': => @model.leaf()?.unstage()
      'atomatigit:fetch': @model.fetch
      'atomatigit:kill': => @model.leaf()?.kill()
      'atomatigit:open': => @model.selection()?.open()
      'atomatigit:push': @model.push
      'atomatigit:refresh': @refresh
      'atomatigit:toggle-focus': @toggleFocus

  # Public: Force a full refresh.
  refresh: =>
    @model.reload().then => @activeView.repaint()

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

  # Public: Checks if the atomatigit pane has focus.
  hasFocus: =>
    @activeView?.is(':focus') or document.activeElement is @activeView

  # Internal: Unfocus when losing focus by keyboard.
  unfocusIfNotActive: =>
    # new element isn't focused as the blur event happens
    @unfocusTimeoutId = setTimeout =>
      @unfocus() unless @hasFocus()
    , 300

  # Public: Focus the atomatigit pane. Refresh if we're not refocusing.
  focus: =>
    if @unfocusTimeoutId?
      clearTimeout(@unfocusTimeoutId)
      @unfocusTimeoutId = null

    @activeView?.focus?() and (@hasClass('focused') or @refresh()) and @addClass 'focused'

  # Public: Unfocus the atomatigit pane.
  unfocus: =>
    @removeClass 'focused'

  # Public: Toggle the focus on the atomatigit pane.
  toggleFocus: =>
    return @focus() unless @hasFocus()
    @unfocus()
    atom.workspace.getActivePane().activate()

  # Public: Toggle the atomatigit pane.
  toggle: =>
    if @hasParent() and @hasFocus()
      @hide()
    else
      @show()

  # Public: Append (if not already) and focus the pane
  show: =>
    atom.workspace.addRightPanel(item: this) unless @hasParent()
    @focus()

  # Public: Close the atomatigit pane.
  hide: =>
    @detach() if @hasParent()
    atom.workspace.getActivePane().activate()

  # Public: Destructor.
  destroy: =>
    @subscriptions?.dispose()
    @detach()

module.exports = RepoView
