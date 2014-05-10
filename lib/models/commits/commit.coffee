ListItem = require '../list-item'
{git} = require '../../git'

module.exports =
class Commit extends ListItem
  commitID: ->
    @get "id"

  shortID: ->
    @commitID()?.substr(0, 6)

  authorName: ->
    @get("author").name

  message: ->
    # The message string should be unicode-encoded. decode/escape repairs the
    # encoding.
    decodeURIComponent escape (@get("message") || "")

  shortMessage: ->
    @message().split("\n")[0]

  open: ->
    @confirmReset()

  confirmReset: ->
    atom.confirm
      message: "Soft-reset head to #{@shortID()}?"
      detailedMessage: @get("message")
      buttons:
        "Reset": @reset
        "Cancel": null

  reset: =>
    git.git "reset #{@commitID()}"

  confirmHardReset: ->
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@shortID()}?"
      detailedMessage: @get("message")
      buttons:
        "Cancel": null
        "Reset": @hardReset

  hardReset: =>
    git.git "reset --hard #{@commitID()}"
