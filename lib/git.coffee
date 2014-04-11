gift = require 'gift'
{Events} = require 'backbone'

class Git extends Events
  constructor: (path) ->
    @gift = gift path

  diff: (flags, filename, callback) ->
    @gift.diff flags, filename, @callbackWithErrors(callback)

  add: (filename, callback) ->
    @gift.add filename, @callbackWithErrors(callback)

  git: (command, callback) ->
    @gift.git command, @callbackWithErrors(callback)

  callbackWithErrors: (callback) ->
    (error, value) ->
      if error
        ErrorModel.set_message "#{error}"
      else
        callback value
        trigger "change"

git = {}
if atom.project
  git = new Git atom.project.getRepo().getWorkingDirectory()

module.exports =
  Git: Git
  git: git
