Repo     = require './models/repo'
RepoView = require './views/repo-view'

module.exports =
  configDefaults:
    debug: false
    pre_commit_hook: ''

  activate: (state) ->
    @repo = new Repo()
    @repo.reload().then =>
      @repoView = new RepoView(@repo)
      @insertCommands()
      @focus()

  insertCommands: ->
    atom.workspaceView.command 'atomatigit:show',  => @focus()
    atom.workspaceView.command 'atomatigit:close', => @close()

  close: ->
    @repoView.detach() if @repoView.hasParent()

  focus: ->
    atom.workspaceView.appendToRight(@repoView) unless @repoView.hasParent()
    @repo.reload().then =>
      @repoView.focus()

  deactivate: ->
    @repoView.destroy()
    @repo.destroy()
