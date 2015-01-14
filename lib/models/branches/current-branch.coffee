git         = require '../../git'
LocalBranch = require './local-branch'
{Commit}    = require '../commits'
ErrorView   = require '../../views/error-view'

# Public: CurrentBranch class that extends the {LocalBranch} prototype.
class CurrentBranch extends LocalBranch
  # Public: Constructor.
  #
  # branchExisting - If the branch is existing as {Boolean}.
  initialize: (branchExisting) ->
    @reload() if branchExisting

  # Public: Reload the branch HEAD.
  reload: ({silent}={}) =>
    git.revParse('HEAD', 'abbrev-ref': true).then (@name) =>
      git.getCommit('HEAD').then (gitCommit) =>
        @commit = new Commit(gitCommit)
        if !silent
          @trigger 'repaint'
          @compareCommits() if atom.config.get('atomatigit.display_commit_comparisons')
    .catch (error) -> new ErrorView(error)

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
