ListItem = require '../list-item'
{git} = require '../../git'

module.exports =
class Commit extends ListItem
  commitID: ->
    @get "id"

  shortID: ->
    @commitID().substr(0, 6)

  authorName: ->
    @get("author").name

  shortCommitMessage: ->
    message = @get "message"
    message.split("\n")[0]

  open: ->
    atom.confirm
      message: "Soft-reset head to #{@short_id()}?"
      detailedMessage: @get("message")
      buttons:
        "Reset": @reset
        "Cancel": null

  reset: =>
    git.git "reset #{@commitID()}"

  confirmHardReset: ->
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@short_id()}?"
      detailedMessage: "Commit message: \"#{@get("message")}\""
      buttons:
        "Cancel": null
        "Reset": @hardReset

  hardReset: =>
    git.git "reset --hard #{@commitID()}"
