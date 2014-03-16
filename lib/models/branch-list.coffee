ListModel = require './list-model'
Branch = require './branch'
_ = require 'underscore'
error_model = require '../error-model'

module.exports =
class BranchList extends ListModel
  model: Branch

  initialize: (list, options) ->
    @repo = options.repo

  reload: ->
    @repo.branches (e, locals) =>
      error_model.set_message "#{e}, #{locals}" if e

      @repo.remotes (e, remotes) =>
        error_model.set_message "#{e}, #{remotes}" if e
        @refresh locals, remotes

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

  local: ->
    @filter (branch) -> branch.local()

  remote: ->
    @filter (branch) -> branch.remote()

  error_callback: (e, f)=>
    error_model.set_message "#{f}" if e
    @trigger "repo:reload"
