Repo     = require './models/repo'
RepoView = require './views/repo-view'

module.exports =
  configDefaults:
    pre_commit_hook: '',

  atomatigitView: null
  repo: null
  repoView: null

  activate: (state) ->
    @repo     ?= new Repo()
    @repoView ?= new RepoView(@repo)

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
    @repoView = null
    @repo = null
