ListItemModel = require './list-item-model'
error_model = require '../error-model'

module.exports =
##
# Branch expects to be initialized with an object:
# {
#   name: "string",
#   commit: object
# }
class Branch extends ListItemModel
  initialize: (args) ->
    @set unpushed: false
    @trigger "change"

  repo: ->
    @get "repo"

  short_commit_id: ->
    commit = @get("commit")
    commit.id.substr(0, 6) if commit

  short_commit_message: ->
    commit = @get("commit")
    return "" if not commit
    message = commit.message.split("\n")[0]
    if message.length > 50
       message = message.substr(0, 50) + "..."
     message

  name: ->
    @get "name"

  local_name: ->
    if @local()
      @name()
    else
      @name().replace /.*?\//, ""

  remote_name: ->
    if @local()
      ""
    else
      @name().replace /\/.*/, ""

  unpushed: ->
    @get "unpushed"

  kill: ->
    atom.confirm
      message: "Delete branch #{@name()}?"
      buttons:
        "Delete": => @kill_on_sight()
        "Cancel": null

  kill_on_sight: ->
    if @local()
      @repo().git "branch -D #{@name()}", @error_callback
    else
      @repo().git "push -f #{@remote_name()} :#{@local_name()}", @error_callback

  remote: ->
    @get "remote"

  local: ->
    !@remote()

  checkout: (callback)->
    @repo().git "checkout #{@local_name()}", @error_callback

  error_callback: (e, f)=>
    error_model.set_message "#{e}" if e
    @trigger "repo:reload"
