{Model} = require 'backbone'

console.log "I GOT HERE"

module.exports =
class Error extends Model
  initialize: ->
    @set message: ""

  set_message: (message) ->
    @set message: message

  markup: ->
    message = @get "message"
    message.replace /\n/g, "<br />"
