{Model} = require 'backbone'
FileList = require './file-list'
gift = require 'gift'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @git = gift(@get "path")
    @file_list = new FileList []

  refresh: ->
    console.log "refreshing..."
    @git.status (_, repo_status) =>
      console.log "callback"
      @file_list.refresh repo_status.files
    # @git.branch (_, head) =>
    #   @branch_brief_view.refresh head
