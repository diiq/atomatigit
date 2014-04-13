List = require '../list'
Commit = require './commit'
{git} = require '../../git'

module.exports =
class CommitList extends List
  model: Commit

  reload: (branch) ->
    @branch = branch
    git.commits @branch.name(), @repopulate

  repopulate: (commit_hashes) =>
    @reset(commit_hashes)
    @select @selected_index
