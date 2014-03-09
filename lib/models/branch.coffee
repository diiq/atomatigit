{Model} = require 'backbone'

module.exports =
##
# Branch expects to be initialized with an object:
# {
#   name: "string",
#   commit: object
# }
class Branch extends Model
  refresh: (head) ->
    @set head

  short_commit_id: ->
    @get("commit").id.substr(0, 6)

  short_commit_message: ->
    @get("commit").message.substr(0, 30)

  name: ->
    @get "name"
