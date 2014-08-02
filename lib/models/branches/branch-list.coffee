_ = require 'lodash'

git          = require '../../git'
List         = require '../list'
LocalBranch  = require './local-branch'
RemoteBranch = require './remote-branch'

# Public: BranchList class that extends the {List} prototype.
class BranchList extends List
  # Public: Reload the branch list.
  reload: =>
    git.branches()
    .then (branches) => @addLocals(branches)
    .catch (error) -> new ErrorView(error)
#    git.remoteRefs().then (branches) => @addRemotes(branches)

  # Public: Add local branches to the branch list.
  #
  # locals - The locals to add as {Array}.
  addLocals: (locals) =>
    _.each @local(), (branch) => @remove branch
    _.each locals, (branch) => @add new LocalBranch(branch)

  # Public: Add remote branches to the branch list.
  #
  # remotes - The remote branches as {Array}.
  addRemotes: (remotes) =>
    _.each @remote(), (branch) => @remove branch
    _.each remotes, (branch) => @add new RemoteBranch(branch)

    @select @selectedIndex

  # Public: Return the local branches from the branch list.
  #
  # Returns the local branches as {Array}.
  local: ->
    @filter (branch) -> branch.local

  # Public: Return the remote branches from the branch list.
  #
  # Returns the remote branches as {Array}.
  remote: ->
    @filter (branch) -> branch.remote

module.exports = BranchList
