Repo      = require './models/repo'
RepoView  = require './views/repo-view'
ErrorView = require './views/error-view'

module.exports =
  configDefaults:
    debug: false
    pre_commit_hook: ''

  repo: null
  repoView: null

  # Public: Package activation.
  activate: (state) ->
    return @errorNoGitRepo() unless atom.project.getRepo()
    @insertCommands()
    @show()

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
  deactivate: =>
    @repo.destroy()
    @repoView.destroy()

  # Internal: Display error message if the project is no git repository.
  errorNoGitRepo: ->
    new ErrorView(message: 'Project is no git repository!')

  # Internal: Register package commands with atom.
  insertCommands: ->
    atom.workspaceView.command 'atomatigit:show', => @show()
    atom.workspaceView.command 'atomatigit:close', => @hide()
