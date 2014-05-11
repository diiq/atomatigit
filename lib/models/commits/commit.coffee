ListItem = require '../list-item'
{git} = require '../../git'

module.exports =
class Commit extends ListItem
  unicodify: (s) ->
    decodeURIComponent escape s

  commitID: ->
    @get "id"

  shortID: ->
    @commitID()?.substr(0, 6)

  authorName: ->
    @unicodify @get("author").name

  message: ->
    @unicodify (@get("message") || "")

  shortMessage: ->
    @message().split("\n")[0]

  open: ->
    @confirmReset()

  confirmReset: ->
    atom.confirm
      message: "Soft-reset head to #{@shortID()}?"
      detailedMessage: @message()
      buttons:
        "Reset": @reset
        "Cancel": null

  reset: =>
    git.git "reset #{@commitID()}"

  confirmHardReset: ->
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@shortID()}?"
      detailedMessage: @message()
      buttons:
        "Cancel": null
        "Reset": @hardReset

  hardReset: =>
    git.git "reset --hard #{@commitID()}"
