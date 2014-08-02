{$, View} = require 'atom'

class ErrorView extends View
  @content: ({message}) ->
    @div =>
      @div class: 'overlay from-bottom atomatigit-error', outlet: 'messagePanel', =>
        @div class: 'panel-body padded error-message', message

  initialize: ->
    @messagePanel.on 'click', => @detach()
    atom.workspaceView.append(this)
    setTimeout =>
      @detach()
    , 10000

module.exports = ErrorView
