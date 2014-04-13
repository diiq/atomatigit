# ListModel = require './list-model'
# Commit = require './commit'
# _ = require 'underscore'
# error_model = require '../error-model'
#
# module.exports =
# class CommitList extends ListModel
#   model: Commit
#
#   initialize: (models, options) ->
#     @repo = options.repo
#
#   reload: (branch) ->
#     @branch = branch
#     @repo.commits @branch.name(), (e, commits) =>
#       error_model.set_message "#{e}, #{commits}" if e
#       @refresh(commits)
#
#   refresh: (commit_hashes) ->
#     @reset()
#     _.each commit_hashes, (commit) =>
#       commit = @add commit
#       commit.on "repo:reload", =>
#         @trigger "repo:reload"
#
#     @trigger "refresh"
#     @select @selected
