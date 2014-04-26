ListItem = require '../list-item'
Diff = require '../diffs/diff'
{git} = require '../../git'

module.exports =
class File extends ListItem
  initialize: ->
    @set diff: false
    @loadDiff()
    @deselect()

  path: ->
    @get "path"

  showDiffP: ->
    @get "diff"

  diff: ->
    @sublist

  stage: ->
    git.add @path(), => null

  setDiff: (diff) =>
    @sublist = new Diff diff
    @trigger "change:diff"

  toggleDiff: ->
    @set diff: not @get "diff"

  useSublist: ->
    @showDiffP()

  open: ->
    atom.workspaceView.open @path()

  # Interface you'll have to override

  unstage: -> null

  kill: -> null

  loadDiff: -> null

  stagedP: -> false

  unstagedP: -> false

  untrackedP: -> false
