gift = require 'gift'
{Model} = require 'backbone'
_ = require 'underscore'


class Git extends Model
  initialize: (options) ->
    @gift = gift options.path
    @clearMessage()

  diff: (path, callback, options) ->
    options ||= {}
    flags = options.flags || ""
    @gift.diff "", flags, path, @callbackWithErrorsNoChange (diffs) =>
        callback diffs[0] if callback

  add: (filename, callback) ->
    @gift.add filename, @callbackWithErrors(callback)

  git: (command, callback) ->
    @gift.git command, @callbackWithErrors(callback)

  status: (callback) ->
    @gift.status @callbackWithErrorsNoChange (status) =>
      callback @_tidyStatus status.files

  branch: (callback) ->
    @gift.branch @callbackWithErrorsNoChange(callback)

  branches: (callback) ->
    @gift.branches @callbackWithErrorsNoChange(callback)

  remotes: (callback) ->
    @gift.remotes @callbackWithErrorsNoChange(callback)

  remoteFetch: (callback) ->
    @gift.remote_fetch

  createBranch: (name, callback) ->
    @gift.create_branch name, @callbackWithErrors(callback)

  remotePush: (remote_branch, callback) ->
    @gift.remote_push remote_branch, @callbackWithErrors(callback)

  callbackWithErrors: (callback) =>
    (error, value) =>
      if error
        @setMessage "#{error}"
      else
        callback value if callback
        @trigger "change"

  callbackWithErrorsNoChange: (callback) =>
    (error, value) =>
      if error
        @setMessage "#{error}"
      else
        callback value if callback


  incrementTaskCounter: ->
    @task_counter += 1
    @trigger("change:task_counter")

  decrementTaskCounter: ->
    @task_counter -= 1
    @trigger("change:task_counter")

  clearTaskCounter: ->
    @task_counter = 0
    @trigger("change:task_counter")

  workingP: ->
    @task_counter == 0


  setMessage: (message) ->
    @set message: message
    @trigger "error"

  messageMarkup: ->
    message = @get "message"
    message.replace /\n/g, "<br />"

  clearMessage: () ->
    @set message: ""


  _tidyStatus: (filehash) ->
    output =
      untracked: []
      unstaged: []
      staged: []

    _.each filehash, (status, path) =>
      file = {path: path, status: status}

      if not status.tracked
        output.untracked.push file
      if status.staged
        output.staged.push file
      if (status.tracked and not status.staged) or
         (status.type && status.type.length == 2)
        output.unstaged.push file

    output

git = {}
if atom.project
  git = new Git path: atom.project.getRepo().getWorkingDirectory()

module.exports =
  Git: Git
  git: git
