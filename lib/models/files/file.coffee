_ = require 'underscore'

ListItem = require '../list-item'
Diff = require '../diffs/diff'
{git} = require '../../git'

module.exports =
class File extends ListItem
  initialize: (path) ->
    @set 'path': path.path
    @set 'diffType': path.type
    @set diff: false
    @loadDiff()
    @deselect()

  path: ->
    @get "path"

  showDiffP: ->
    @get "diff"

  diff: ->
    @sublist

  diffType: ->
    @get "diffType"

  stage: ->
    git.add @path(), -> null

  setDiff: (diff) =>
    @sublist = new Diff diff
    @trigger "change:diff"

  toggleDiff: ->
    @set diff: not @get "diff"

  useSublist: ->
    @showDiffP()

  open: ->
    atom.workspaceView.open @path()

  commitMessage: =>
    switch_state = (type) ->
      switch type
        when "M" then "modified:   "
        when "R" then "renamed:    "
        when "D" then "deleted:    "
        when "A" then "new file:   "
        else ""
    "#\t\t#{switch_state(@diffType())}#{@path()}\n"

  # Interface you'll have to override

  unstage: -> null

  kill: -> null

  loadDiff: -> null

  stagedP: -> false

  unstagedP: -> false

  untrackedP: -> false
