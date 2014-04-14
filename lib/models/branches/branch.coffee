ListItem = require '../list-item'
Commit = require '../commits/commit'
{git} = require '../../git'

module.exports =
class Branch extends ListItem
  selfSelect: ->
    console.log "here", this
    super

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

  open: ->
    @checkout()

  checkout: (callback)->
    git.git "checkout #{@localName()}"

  push: -> null

  delete: => null
