git    = require '../../git'
Branch = require './branch'

class RemoteBranch extends Branch

  remote: true
  local: false

  # Public: Delete the remote branch.
  #
  # Returns the [Description] as {String}.
  delete: =>
    git.cmd "push -f #{@remoteName()} :#{@localName()}"

  # Public: Return the local name.
  #
  # Returns the local name as {String}.
  localName: ->
    @name().replace /.*?\//, ''

  # Public: Return the remote name.
  #
  # Returns the remote name as {String}.
  remoteName: ->
    @name().replace /\/.*/, ''

module.exports = RemoteBranch
