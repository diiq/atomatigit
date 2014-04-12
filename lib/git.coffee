gift = require 'gift'
{Events} = require 'backbone'
_ = require 'underscore'

ErrorModel = require './error-model'

class Git
  constructor: (path) ->
    @gift = gift path
    window.gift = @gift
    _.extend(this, Events)

  diff: (path, callback, options) ->
    options ||= {}
    flags = options.flags || ""
    @gift.diff "", flags, path, (error, diffs) ->
      if error
        ErrorModel.set_message "#{error}"
      else
        callback diffs[0] if callback

  add: (filename, callback) ->
    @gift.add filename, @callbackWithErrors(callback)

  git: (command, callback) ->
    @gift.git command, @callbackWithErrors(callback)

  status: (callback) ->
    @gift.status (error, status) =>
      if error
        ErrorModel.set_message "#{error}"
      else
        callback @_tidyStatus status.files

  _tidyStatus: (filehash) ->
    output =
      untracked: []
      unstaged: []
      staged: []

    _.each filehash, (status, path) =>
      file = {path: path, status: status}

      if status.untracked
        output.untracked.push file
      if status.staged
        output.staged.push file
      if (status.tracked and not status.staged) or
         (status.type && status.type.length == 2)
        output.unstaged.push file

    output

  branch: (callback) ->
    @gift.branch @callBackWithErrors(callback)

  remoteFetch: (callback) ->
    @gift.remote_fetch

  createBranch: (name, callback) ->
    @gift.create_branch name, @callbackWithErrors(callback)

  remotePush: (remote_branch, callback) ->
    @gift.remote_push remote_branch, @callbackWithErrors(callback)

  callbackWithErrors: (callback) =>
    (error, value) =>
      if error
        ErrorModel.set_message "#{error}"
      else
        callback value if callback
        @trigger "change"


git = {}
if atom.project
  git = new Git atom.project.getRepo().getWorkingDirectory()

module.exports =
  Git: Git
  git: git
