{Model} = require 'backbone'

module.exports =
class Error extends Model
  initialize: ->
    @set
      message: ""

  set_message: (message) ->
    @set message: message
    @trigger "error"

  clear_task_counter: ->
    @set task_counter: 0

  working: ->
    @get("task_counter") > 0

  markup: ->
    message = @get "message"
    message.replace /\n/g, "<br />"
