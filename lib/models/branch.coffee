{Model} = require 'backbone'

module.exports =
##
# Branch expects to be initialized with an object:
# {
#   name: "string",
#   commit: object
# }
class Branch extends Model
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

  unpushed: ->
    @get "unpushed"

  selected: ->
    @get "selected"

  select: ->
    @set selected: true

  unselect: ->
    @set selected: false

  remote: ->
    @get "remote"

  local: ->
    !@remote()

  self_select: =>
    @collection.select @collection.indexOf(this)
