Repo      = require './models/repo'
RepoView  = require './views/repo-view'
ErrorView = require './views/error-view'

module.exports =
  configDefaults:
    debug: false
    pre_commit_hook: ''

  activate: (state) ->
    @insertCommands()
    return @errorNoGitRepo() unless atom.project.getRepo()

    @repo = new Repo()
    @repo.reload().then =>
      @repoView = new RepoView(@repo)
      @focus()

  insertCommands: ->
    atom.workspaceView.command 'atomatigit:show',  => @focus()
    atom.workspaceView.command 'atomatigit:close', => @close()

  close: ->
    return @errorNoGitRepo() unless atom.project.getRepo()
    @repoView.detach() if @repoView?.hasParent()

  focus: ->
    return @errorNoGitRepo() unless atom.project.getRepo()
    atom.workspaceView.appendToRight(@repoView) unless @repoView?.hasParent()
    @repo.reload().then =>
      @repoView.focus()

  deactivate: ->
    @repoView.destroy()
    @repo.destroy()

  errorNoGitRepo: ->
    new ErrorView(message: 'Project is no git repository!')
