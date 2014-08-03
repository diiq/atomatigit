_          = require 'lodash'
prettyjson = require 'prettyjson'
{$, View}  = require 'atom'

class ErrorView extends View
  @content: ({message}) ->
    @div =>
      @div class: 'overlay from-bottom atomatigit-error', outlet: 'messagePanel', =>
        @div class: 'panel-body padded error-message', message

  initialize: (error) ->
    if atom.config.get('atomatigit.debug')
      console.trace prettyjson.render(error, noColor: true)

    @messagePanel.on 'click', => @detach()
    atom.workspaceView.append(this)
    setTimeout =>
      @detach()
    , 10000

module.exports = ErrorView
