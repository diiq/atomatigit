_ = require 'lodash'

git       = require '../../git'
Diff      = require '../diffs/diff'
ListItem  = require '../list-item'
ErrorView = require '../../views/error-view'

class File extends ListItem
  # Public: Constructor
  #
  # path - The file path as {String}.
  initialize: (file) ->
    @set file
    @set diff: false
    @loadDiff()
    @deselect()

  # Public: Return the 'path' property.
  #
  # Returns the 'path' property as {String}.
  path: =>
    @get 'path'

  # Public: Return the 'diff' property.
  #
  # Returns the 'diff' property as {String}.
  showDiffP: =>
    @get 'diff'

  # Public: Return the diff sublist.
  #
  # Returns the diff sublist as {List}.
  diff: =>
    @sublist

  # Public: Stage the changes made to this file.
  stage: =>
    git.add(@path())
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Internal: Set the file diff to diff.
  #
  # diff - The diff to set the file diff to as {Diff}.
  setDiff: (diff) =>
    @sublist = new Diff(diff)
    @trigger 'change:diff'

  # Public: Toggle the diff visibility.
  toggleDiff: =>
    @set diff: not @get('diff')

  useSublist: =>
    @showDiffP()

  # Public: Open the file in atom.
  open: =>
    atom.workspace.open @path()

  commitMessage: =>
    switchState = (type) ->
      switch type
        when 'M' then 'modified:   '
        when 'R' then 'renamed:    '
        when 'D' then 'deleted:    '
        when 'A' then 'new file:   '
        else ''
    "#\t\t#{switchState(@getMode())}#{@path()}\n"

  # Public: Checkout the file to the index.
  checkout: =>
    git.checkoutFile(@path())
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  #############################################################################
  # Interface you will have to override                                       #
  #############################################################################

  unstage: -> return

  kill: -> return

  loadDiff: -> return

  getMode: -> return

  isStaged: -> false

  isUnstaged: -> false

  isUntracked: -> false

module.exports = File
