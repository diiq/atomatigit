gift = require 'gift'
{Model} = require 'backbone'
_ = require 'underscore'


class Git extends Model
  task_counter: 0
  initialize: (options) ->
    @setPath(options?.path)
    @clearMessage()

  setPath: (path) ->
    @path = path || atom.project.getRepo().getWorkingDirectory()
    @gift = gift @path

  diff: (path, callback, options) ->
    options ||= {}
    flags = options.flags || ""
    @gift.diff "", flags, [path], @callbackWithErrorsNoChange (diffs) ->
      callback diffs[0] if callback

  add: (filename, callback) ->
    @gift.add filename + " --no-ignore-removal", @callbackWithErrors(callback)

  git: (command, callback) ->
    @gift.git command, @callbackWithErrors(callback)

  gitNoChange: (command, callback) ->
    @gift.git command, @callbackWithErrorsNoChange(callback)

  status: (callback) ->
    @gift.status @callbackWithErrorsNoChange (status) ->
      callback status?.files

  branch: (callback) ->
    @gift.branch @callbackWithErrorsNoChange(callback)

  branches: (callback) ->
    @gift.branches @callbackWithErrorsNoChange(callback)

  remotes: (callback) ->
    @gift.remotes @callbackWithErrorsNoChange(callback)

  commits: (branch_name, callback) ->
    @gift.commits branch_name, @callbackWithErrorsNoChange(callback)

  remoteFetch: (remote, callback) ->
    @gift.remote_fetch remote, @callbackWithErrors(callback)

  createBranch: (name, callback) ->
    @gift.create_branch name, @callbackWithErrors(callback)

  remotePush: (remote_branch, callback) ->
    @gift.remote_push remote_branch + " -u", @callbackWithErrors(callback)

  callbackWithErrors: (callback) =>
    @incrementTaskCounter()
    (error, value) =>
      @decrementTaskCounter()
      if error
        @setMessage "#{error}"
      else
        callback value if callback
        @trigger "reload"

  callbackWithErrorsNoChange: (callback) =>
    @incrementTaskCounter()
    (error, value) =>
      @decrementTaskCounter()
      if error
        @setMessage "#{error}"
      else
        callback value if callback


  incrementTaskCounter: ->
    @task_counter += 1
    @trigger("change:task_counter") if @task_counter == 1

  decrementTaskCounter: =>
    @task_counter -= 1
    @trigger("change:task_counter") if @task_counter == 0

  clearTaskCounter: =>
    @task_counter = 0
    @trigger("change:task_counter")

  workingP: ->
    @task_counter > 0


  setMessage: (message) ->
    @set message: message
    @trigger "error"

  messageMarkup: ->
    message = @get "message"
    message.replace /\n/g, "<br />"

  clearMessage: ->
    @set message: ""

git = {}
if atom.project
  git = new Git()

module.exports =
  Git: Git
  git: git
