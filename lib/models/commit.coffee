istItemModel = require './list-item-model'

module.exports =
##
# Branch expects to be initialized with an object:
# {
#   name: "string",
#   commit: object
# }
class Commit extends ListItemModel

  repo: ->
    @get "repo"

  id: ->
    @get "id"

  short_id: ->
    @id().substr(0, 6)
