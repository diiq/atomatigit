Repo     = require './models/repo'
RepoView = require './views/repo-view'

module.exports =
  configDefaults:
    pre_commit_hook: '',

  atomatigitView: null

  activate: (state) ->
    @repo     = new Repo()
    @repoView = new RepoView(@repo)

    @insertCommands()

  insertCommands: ->
    atom.workspaceView.command 'atomatigit:show',  => @focus()
    atom.workspaceView.command 'atomatigit:close', => @close()

  close: ->
    @repoView.detach() if @repoView.hasParent()

  focus: ->
    atom.workspaceView.appendToRight(@repoView) unless @repoView.hasParent()
    @repo.reload()
    @repoView.focus()

  deactivate: ->
    @repoView.destroy()
    @repo.destroy()
