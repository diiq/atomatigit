Repo      = require './models/repo'
RepoView  = require './views/repo-view'
ErrorView = require './views/error-view'

module.exports =
  configDefaults:
    debug: false
    pre_commit_hook: ''

  # Public: Package activation.
  activate: (state) ->
    return @errorNoGitRepo() unless atom.project.getRepo()

    @repo = new Repo()
    @repo.reload().then =>
      @repoView = new RepoView(@repo)
      @focus()
    @insertCommands()

  # Public: Close the atomatigit pane.
  close: =>
    return @errorNoGitRepo() unless atom.project.getRepo()
    @repoView.detach() if @repoView?.hasParent()

  # Public: Open (or focus) the atomatigit window.
  focus: =>
    return @errorNoGitRepo() unless atom.project.getRepo()
    unless @repo
      @repo = new Repo()
      @repo.reload().then =>
        @repoView = new RepoView(@repo)
        atom.workspaceView.appendToRight(@repoView) unless @repoView?.hasParent()
        @repo.reload().then =>
          @repoView.focus()
    else
      atom.workspaceView.appendToRight(@repoView) unless @repoView?.hasParent()
      @repo.reload().then =>
        @repoView.focus()

  # Internal: Destroy atomatigit instance.
  deactivate: =>
    @repo.destroy()
    @repoView.destroy()

  # Internal: Display error message if the project is no git repository.
  errorNoGitRepo: ->
    new ErrorView(message: 'Project is no git repository!')

  # Internal: Register package commands with atom.
  insertCommands: =>
    atom.workspaceView.command 'atomatigit:show', @focus
    atom.workspaceView.command 'atomatigit:close', @close
