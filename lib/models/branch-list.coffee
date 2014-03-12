ListModel = require './list-model'
Branch = require './branch'
_ = require 'underscore'

module.exports =
class BranchList extends ListModel
  model: Branch

  refresh: (heads) ->
    @reset()
    _.each heads, (branch) =>
      console.log branch
      @add branch
      #b.fetch()

    @trigger "refresh"
    @select @selected

  local: ->
    console.log @models
    @models

  remote: ->
    []
