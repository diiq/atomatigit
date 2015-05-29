{$, View, TextEditorView} = require 'atom-space-pen-views'
ErrorView = require './error-view'
OutputView = require './output-view'
git = require '../git'

class InputView extends View
  @content: ({message}={}) ->
    @div class: 'overlay from-top', =>
      @subview 'inputEditor', new TextEditorView(mini: true, placeholderText: message)

  initialize: ({callback}={}) ->
    @currentPane = atom.workspace.getActivePane()
    atom.views.getView(atom.workspace).appendChild(@element)
    @inputEditor.focus()
    @on 'focusout', @detach
    atom.commands.add @element, 'core:cancel', ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'atomatigit:toggle')
    atom.commands.add @inputEditor.element, 'core:confirm', =>
      callback?(@inputEditor.getText())

module.exports = InputView
