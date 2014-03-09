{Model} = require 'backbone'
FileList = require './file-list'
Branch = require './branch'
gift = require 'gift'

module.exports =
class Repo extends Model
  initialize: (opts) ->
    @git = gift(@get "path")
    @file_list = new FileList []
    @current_branch = new Branch {}

  refresh: ->
    @git.status (_, repo_status) =>
      @file_list.refresh repo_status.files
    @git.branch (_, head) =>
      @current_branch.refresh head

  stage: ->
    @git.add @file_list.selection().filename(), (errors) =>
      console.log errors if errors
      @refresh()
