AtomatigitView = require './atomatigit-view'

module.exports =
  atomatigitView: null

  activate: (state) ->
    atom_git = atom.project.getRepo()
    path = atom_git.getWorkingDirectory()
    @atomatigitView = new AtomatigitView(state.atomatigitViewState, path)

  deactivate: ->
    @atomatigitView.destroy()

  serialize: ->
    atomatigitViewState: @atomatigitView.serialize()
