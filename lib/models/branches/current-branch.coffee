LocalBranch = require './local-branch'

{git} = require '../../git'

module.exports =
class CurrentBranch extends LocalBranch
  initialize: (branchExisting) ->
    if branchExisting then @reload()

  reload: ->
    git.branch (head) =>
      @set head

    # git.gitNoChange "log @{u}..", (output) =>
    #   @set unpushed: (output != "")

  head: ->
    "HEAD"

  delete: -> null

  checkout: -> null
