{$, EditorView, View} = require 'atom'
ErrorView = require './error-view'
OutputView = require './output-view'
git = require '../git'

class InputView extends View
  @content: ({message}={}) ->
    @div class: 'overlay from-top', =>
      @subview 'inputEditor', new EditorView(mini: true, placeholderText: message)

  initialize: ({callback}={}) ->
    @currentPane = atom.workspace.getActivePane()
    atom.workspaceView.append(this)
    @inputEditor.focus()
    @on 'core:cancel', @detach
    @inputEditor.on 'core:confirm', =>
      @detach()
      callback?(@inputEditor.getText())

module.exports = InputView
