Branch = require './branch'
{git} = require '../git'

module.exports =
class LocalBranch extends ListItem
  remote: false

  local: true

  unpushed: ->
    @get "unpushed"

  delete: ->
    git.git "branch -D #{@name()}", @error_callback

  # TODO tracking branch or something?
  remote_name: -> ""

  checkout: (callback)->
    git.git "checkout #{@local_name()}"
