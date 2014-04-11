ListItem = require './list-item'
Diff = require './diff'
{git} = require '../git'

module.exports =
class File extends ListItem
  initialize: ->
    @set diff: false
    #@loadDiff()

  path: ->
    @get "path"

  showDiffP: ->
    @get "diff"

  diff: ->
    @sublist

  stage: ->
    git.add @path(), => null

  setDiff: (diffs) =>
    @sublist = new Diff diffs[0].diff

  toggleDiff: ->
    @set diff: not @get("diff")

  open: ->
    atom.workspaceView.open @path()

  # Interface you'll have to override

  unstage: -> null

  kill: -> null

  loadDiff: -> null

  stagedP: -> false

  unstagedP: -> false

  untrackedP: -> false
