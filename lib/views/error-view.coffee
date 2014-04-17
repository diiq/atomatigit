{View} = require 'atom'

module.exports =
class ErrorView extends View
  @content: ->
    @div =>
      @div class: "loading loading-spinner-small spinner", outlet: "spinner"
      @div class: "inset-panel atomatigit-error", outlet: "message_panel", =>
        @div class: "panel-heading", =>
          @div class: "close-button", outlet: "close_button", =>
            @raw("&#10006;")
          @text "git output"
        @div class: "panel-body padded error-message", outlet: "message"

  initialize: (model) ->
    @model = model
    @model.on "error", => @repaint()
    @model.on "change:task_counter", => @toggle_spinner()
    @close_button.on "click", => @message_panel.hide()

  repaint: ->
    @message_panel.show()
    @message.html @model.messageMarkup()

  toggle_spinner: ->
    if @model.workingP()
      @spinner.show()
    else
      @spinner.hide()
