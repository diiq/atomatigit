{$, EditorView, View} = require 'atom'
ErrorView = require './error-view'
OutputView = require './output-view'
git = require '../git'

class InputCommandView extends View
  @content: (message) ->
    @div class: 'overlay from-top', =>
      @subview 'inputEditor', new EditorView(mini: true, placeholderText: message)

  initialize: ->
    @currentPane = atom.workspace.getActivePane()
    atom.workspaceView.append(this)
    @inputEditor.focus()
    @on 'core:cancel', => @detach()
    @inputEditor.on 'core:confirm', @executeCustomGitCommand

  executeCustomGitCommand: =>
    @detach()

    git.cmd @inputEditor.getText()
    .then (output) -> new OutputView(output)
    .catch (error) -> new ErrorView(error)

module.exports = InputCommandView
