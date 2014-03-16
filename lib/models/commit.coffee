ListItemModel = require './list-item-model'
error_model = require '../error-model'

module.exports =
class Commit extends ListItemModel
  repo: ->
    @get "repo"

  commit_id: ->
    @get "id"

  short_id: ->
    @commit_id().substr(0, 6)

  short_commit_message: ->
    message = @get "message"
    message = message.split("\n")[0]
    if message.length > 50
      message = message.substr(0, 50) + "..."
    message

  reset_to: ->
    atom.confirm
      message: "Soft-reset head to #{@short_id()}?"
      detailedMessage: @get("message")
      buttons:
        "Reset": =>
          @repo().git "reset #{@commit_id()}", @error_callback
          @trigger "repo:reload"
        "Cancel": null

  reset_hard_to: ->
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@short_id()}?"
      detailedMessage: "Commit message: \"#{@get("message")}\""
      buttons:
        "Cancel": null
        "Reset": =>
          @repo().git "reset --HARD #{@commit_id()}", @error_callback
          @trigger "repo:reload"

  error_callback: (e)=>
    error_model.set_message "#{e}" if e
    @trigger "repo:reload"
