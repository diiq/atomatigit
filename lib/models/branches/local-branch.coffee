Branch = require './branch'

{git} = require '../../git'

module.exports =
class LocalBranch extends Branch
  remote: false

  local: true

  unpushed: ->
    @get "unpushed"

  delete: ->
    git.git "branch -D #{@name()}"

  # TODO tracking branch or something?
  remoteName: -> ""

  checkout: (callback) ->
    git.git "checkout #{@localName()}"

  push: (remote) ->
    remote ||= "origin #{@name()}"
    git.remotePush remote
