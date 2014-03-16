{View} = require 'atom'

module.exports =
class ErrorView extends View
  @content: ->
    @div class: "inset-panel atomatigit-error", =>
      @div class: "panel-heading", =>
        @div class: "close-button", outlet: "close_button", =>
          @raw("&#10006;")
        @text "git output"
      @div class: "panel-body padded error-message", outlet: "message"

  initialize: (model) ->
    @model = model
    @model.on "change", => @repaint()
    @close_button.on "click", => @hide()

  repaint: ->
    @show()
    @message.html @model.markup()
