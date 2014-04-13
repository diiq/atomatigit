Branch = require './branch'
{git} = require '../git'

module.exports =
class RemoteBranch extends Branch
  remote: true

  local: false

  unpushed: -> null

  delete: ->
    git.git "push -f #{@remote_name()} :#{@local_name()}", @error_callback

  localName: ->
    @name().replace /.*?\//, ""

  remoteName: ->
    @name().replace /\/.*/, ""
