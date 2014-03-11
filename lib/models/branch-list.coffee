ListModel = require './list-model'
Branch = require './branch'
_ = require 'underscore'

module.exports =
class FileList extends ListModel
  model: Branch

  refresh: (filehash) ->
    @reset()
    _.each branch, (branch) => @add branch

    @trigger "refresh"
    @select @selected

  comparator: (file) ->
    branch.name
