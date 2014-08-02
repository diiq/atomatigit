git       = require '../../git'
Branch    = require './branch'
ErrorView = require '../../views/error-view'

class RemoteBranch extends Branch

  remote: true
  local: false

  # Public: Delete the remote branch.
  #
  # Returns the [Description] as {String}.
  delete: =>
    git.cmd "push -f #{@remoteName()} :#{@localName()}"
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Return the local name.
  #
  # Returns the local name as {String}.
  localName: ->
    @getName().replace /.*?\//, ''

  # Public: Return the remote name.
  #
  # Returns the remote name as {String}.
  remoteName: ->
    @getName().replace /\/.*/, ''

module.exports = RemoteBranch
