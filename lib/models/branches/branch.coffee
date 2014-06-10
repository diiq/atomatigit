ListItem = require '../list-item'
Commit = require '../commits/commit'
{git} = require '../../git'

module.exports =
class Branch extends ListItem
  name: ->
    # The name should be unicode-encoded. decode/escape repairs the
    # encoding.
    decodeURIComponent escape @get "name"

  localName: ->
    @name()

  head: ->
    @get("commit").id

  commit: ->
    new Commit @get "commit"

  remoteName: -> ""

  unpushed: -> false

  kill: ->
    atom.confirm
      message: "Delete branch #{@name()}?"
      buttons:
        "Delete": @delete
        "Cancel": null

  open: ->
    @checkout()

  checkout: (callback)->
    git.git "checkout #{@localName()}"

  push: -> null

  delete: -> null
