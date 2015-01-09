Repo = RepoView = ErrorView = null

module.exports =
  config:
    debug:
      title: 'Debug'
      description: 'Toggle debugging tools'
      type: 'boolean'
      default: false
      order: 1
    pre_commit_hook:
      title: 'Pre Commit Hook'
      description: 'Command to run for the pre commit hook'
      type: 'string'
      default: ''
      order: 2
    show_on_startup:
      title: 'Show on Startup'
      description: 'Check this if you want atomatigit to show up when Atom is loaded'
      type: 'boolean'
      default: false
      order: 3

  repo: null
  repoView: null

  startup_error_shown: false

  # Public: Package activation.
  activate: (state) ->
    @insertShowCommand()
    ErrorView = require './views/error-view'
    return @errorNoGitRepo() unless atom.project.getRepo()
    Repo      = require './models/repo'
    RepoView  = require './views/repo-view'
    @insertCommands()
    atom.workspaceView.trigger 'atomatigit:show' if atom.config.get('atomatigit.show_on_startup')

  # Public: Close the atomatigit pane.
  hide: ->
    @repoView.detach() if @repoView.hasParent()

  # Public: Open (or focus) the atomatigit window.
  show: ->
    return @errorNoGitRepo() unless atom.project.getRepo()
    @repo ?= new Repo()
    @repoView ?= new RepoView(@repo)
    @repo.reload().then =>
      atom.workspaceView.appendToRight(@repoView) unless @repoView?.hasParent()
      @repoView.focus()

  # Internal: Destroy atomatigit instance.
  deactivate: ->
    @repo.destroy()
    @repoView.destroy()

  # Internal: Display error message if the project is no git repository.
  errorNoGitRepo: ->
    new ErrorView(message: 'Project is no git repository!') if @startup_error_shown
    @startup_error_shown = true

  # Internal: Register show command with atom.
  insertShowCommand: ->
    atom.workspaceView.command 'atomatigit:show', => @show()

  # Internal: Register package commands with atom.
  insertCommands: ->
    atom.workspaceView.command 'atomatigit:close', => @hide()
