{Model} = require 'backbone'

module.exports =
##
# Branch expects to be initialized with an object:
# {
#   name: "string",
#   commit: object
# }
class Branch extends Model
  initialize: ->
    @set unpushed: false

  refresh: (head) ->
    @set head

  short_commit_id: ->
    @get("commit").id.substr(0, 6)

  short_commit_message: ->
    message = @get("commit").message
    message = message.split("\n")[0]
    if message.length > 50
       message = message.substr(0, 50) + "..."
     message

  name: ->
    @get "name"

  unpushed: ->
    @get "unpushed"
