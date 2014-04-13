ListItem = require '../list-item'
Commit = require '../commits/commit'
{git} = require '../../git'

module.exports =
class Branch extends ListItem
  name: ->
    @get "name"

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

  checkout: (callback)->
    git.git "checkout #{@localName()}"

  push: -> null

  delete: => null
