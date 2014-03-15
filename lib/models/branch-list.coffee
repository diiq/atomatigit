ListModel = require './list-model'
Branch = require './branch'
_ = require 'underscore'

module.exports =
class BranchList extends ListModel
  model: Branch

  refresh: (locals, remotes) ->
    @reset()
    _.each locals, (branch) =>
      branch.remote = false
      @add_branch branch

    _.each remotes, (branch) =>
      branch.remote = true
      @add_branch branch

    @trigger "refresh"
    @select @selected

  add_branch: (branch) ->
    branch = @add branch
    branch.on "repo:reload", => @trigger "repo:reload"

  checkout_branch: (callback)->
    repo = @selection().get "repo"
    branch = @selection().local_name()
    repo.git "checkout #{branch}", (e, f, s) =>
      console.log e, f, s if e
      callback()

  local: ->
    @filter (branch) -> branch.local()

  remote: ->
    @filter (branch) -> branch.remote()
