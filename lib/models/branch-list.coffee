_ = require 'underscore'

List = require './list'
LocalBranch = require './local-branch'
RemoteBranch = require './remote-branch'

{git} = require '../git'

module.exports =
class BranchList extends List
  reload: ->
    git.branches @addLocals
    git.remotes @addRemotes

  addLocals: (locals) =>
    _.each @local(), (branch) => @remove branch
    _.each locals, (branch) =>
      @add new LocalBranch branch
    @select @selected_index

  addRemotes: (remotes) =>
    _.each @remote(), (branch) => @remove branch
    _.each remotes, (branch) =>
      @add new RemoteBranch branch
    @select @selected_index

  local: ->
    @filter (branch) -> branch.local

  remote: ->
    @filter (branch) -> branch.remote
