LocalBranch = require './local-branch'

{git} = require '../../git'

module.exports =
class CurrentBranch extends LocalBranch
  initialize: (branchExisting) ->
    @reload() if branchExisting

  reload: ->
    git.branch (head) =>
      @set head

    # git.gitNoChange "log @{u}..", (output) =>
    #   @set unpushed: (output != '')

  head: ->
    'HEAD'

  delete: -> null

  checkout: -> null
