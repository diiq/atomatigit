ListItemModel = require './list-item-model'

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
