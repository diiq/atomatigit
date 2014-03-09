RepoView = require './views/repo-view'
Repo = require './models/repo'

module.exports =
  atomatigitView: null

  activate: (state) ->
    atom_git = atom.project.getRepo()
    path = atom_git.getWorkingDirectory()
    @repo = new Repo({path: path})
    @repo_view = new RepoView(@repo)
    @insert_commands()

  insert_commands: ->
    atom.workspaceView.command "atomatigit:show", => @focus()
    atom.workspaceView.command "atomatigit:close", => @close()

  close: ->
    if @repo_view.hasParent()
      @repo_view.detach()

  focus: ->
    if !@repo_view.hasParent()
      atom.workspaceView.appendToRight(@repo_view)
    @repo.refresh()
    @repo_view.focus()

  deactivate: ->
    @repo_view.destroy()
    @repo.destroy()

  serialize: ->
