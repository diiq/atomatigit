_ = require 'lodash'
git    = require '../../git'
List   = require '../list'
Commit = require './commit'
ErrorView = require '../../views/error-view'

class CommitList extends List
  model: Commit

  # Public: Reload the commit list.
  #
  # branch - The branch to reload the commits for as {Branch}.
  reload: (@branch) =>
    git.log(@branch?.head() ? 'HEAD')
    .then (commits) =>
      @reset _.map(commits, (commit) -> new Commit(commit))
      @trigger 'repaint'
      @select @selectedIndex
    .catch (error) ->
      new ErrorView(error)

module.exports = CommitList
