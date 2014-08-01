{View} = require 'atom'

class ErrorView extends View
  @content: ->
    @div =>
      @div class: 'loading loading-spinner-small spinner', outlet: 'spinner'
      @div class: 'inset-panel atomatigit-error', outlet: 'messagePanel', =>
        @div class: 'panel-heading', =>
          @div class: 'close-button', outlet: 'close_button', =>
            @raw('&#10006;')
          @text 'git output'
        @div class: 'panel-body padded error-message', outlet: 'message'

  initialize: (model) ->
#    @model = model
#    @model.on 'error', => @repaint()
#    @model.on 'change:task_counter', => @toggleSpinner()
    @close_button.on 'click', => @messagePanel.hide()

  repaint: ->
    @messagePanel.show()
    @message.html @model.messageMarkup()

  toggleSpinner: ->
    if @model.workingP()
      @spinner.show()
    else
      @spinner.hide()

module.exports = ErrorView
