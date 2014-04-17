Branch = require './branch'
{git} = require '../../git'

module.exports =
class RemoteBranch extends Branch
  remote: true

  local: false

  delete: ->
    git.git "push -f #{@remoteName()} :#{@localName()}"

  localName: ->
    @name().replace /.*?\//, ""

  remoteName: ->
    @name().replace /\/.*/, ""
