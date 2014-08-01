git      = require '../../git'
ListItem = require '../list-item'
Commit   = require '../commits/commit'

class Branch extends ListItem
  # Public: Return the property 'name'.
  #
  # Returns the name as {String}.
  name: ->
    # The name should be unicode-encoded. decode/escape repairs the
    # encoding.
    decodeURIComponent escape @get('name')

  # Public: Return the local branch name.
  #
  # Returns the local name as {String}.
  localName: ->
    @name()

  # Public: Return the HEAD id.
  #
  # Returns the HEAD as {String}.
  head: ->
    @get('commit').id

  # Public: Return the HEAD.
  #
  # Returns the HEAD as {Commit}.
  commit: ->
    new Commit @get 'commit'

  # Public: Return the remote name.
  #
  # Returns the remote name as {String}.
  remoteName: -> ''

  # Public: Check if the branch is unpushed.
  #
  # Returns: {Boolean}.
  unpushed: -> false

  # Public: Delete the branch.
  kill: ->
    atom.confirm
      message: "Delete branch #{@name()}?"
      buttons:
        'Delete': @delete
        'Cancel': null

  # Public: Open (= checkout) the branch.
  open: ->
    @checkout()

  # Public: Checkout the branch.
  #
  # callback - The callback as {Function}.
  checkout: (callback) ->
    git.checkout @localName()

  # Abstract: Push the branch.
  push: -> return

  # Abstract: Delete the branch.
  delete: -> return

module.exports = Branch
