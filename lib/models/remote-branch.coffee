Branch = require './branch'
{git} = require '../git'

module.exports =
class RemoteBranch extends Branch
  remote: true

  local: false

  unpushed: -> null

  delete: ->
    git.git "push -f #{@remote_name()} :#{@local_name()}", @error_callback

  local_name: ->
    @name().replace /.*?\//, ""

  remote_name: ->
    @name().replace /\/.*/, ""
