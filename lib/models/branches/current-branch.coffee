git         = require '../../git'
LocalBranch = require './local-branch'

# Public: CurrentBranch class that extends the {LocalBranch} prototype.
class CurrentBranch extends LocalBranch
  # Public: Constructor.
  #
  # branchExisting - If the branch is existing as {Boolean}.
  initialize: (branchExisting) ->
    @reload() if branchExisting

  # Public: Reload the branch HEAD.
  reload: ->
    git.revParse().then (head) =>
      @set head

  # Public: Return the HEAD.
  #
  # Returns 'HEAD'.
  head: ->
    'HEAD'

  # Abstract: Delete the branch.
  delete: -> return

  # Public: Checkout the branch. Empty function since this IS our current
  #         branch.
  checkout: -> return

module.exports = CurrentBranch
