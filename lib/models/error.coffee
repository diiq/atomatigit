{Model} = require 'backbone'

module.exports =
class Error extends Model
  initialize: ->
    @set
      message: ""
      task_counter: 0

  set_message: (message) ->
    @set message: message
    @trigger "error"

  increment_task_counter: ->
    @set task_counter: @get("task_counter") + 1

  decrement_task_counter: ->
    @set task_counter: Math.max @get("task_counter") - 1, 0

  clear_task_counter: ->
    @set task_counter: 0

  working: ->
    @get("task_counter") > 0

  markup: ->
    message = @get "message"
    message.replace /\n/g, "<br />"
