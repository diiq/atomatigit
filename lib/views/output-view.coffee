_          = require 'lodash'
prettyjson = require 'prettyjson'
{$, View}  = require 'atom-space-pen-views'

# Public: The {OutputView} class generates an output message box.
class OutputView extends View
  @content: (raw) ->
    message = if _.isString(raw) then raw else raw.message
    @div =>
      @div class: 'overlay from-bottom atomatigit-output', outlet: 'messagePanel', =>
        @div class: 'panel-body padded output-message', message

  # Public: Constructor.
  initialize: (error) ->
    if atom.config.get('atomatigit.debug')
      console.trace prettyjson.render(error, noColor: true)

    @messagePanel.on 'click', @detach
    atom.views.getView(atom.workspace).appendChild(@element)
    setTimeout (=> @detach()), 10000

module.exports = OutputView
