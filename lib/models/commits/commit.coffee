fs = require 'fs-plus'
path = require 'path'

ListItem = require '../list-item'
{git} = require '../../git'

module.exports =
class Commit extends ListItem
  unicodify: (s) ->
    decodeURIComponent escape s

  commitID: ->
    @get "id"

  shortID: ->
    @commitID()?.substr(0, 6)

  authorName: ->
    @unicodify @get("author").name

  message: ->
    @unicodify (@get("message") || "")

  shortMessage: ->
    @message().split("\n")[0]

  open: ->
    @confirmReset()

  confirmReset: ->
    atom.confirm
      message: "Soft-reset head to #{@shortID()}?"
      detailedMessage: @message()
      buttons:
        "Reset": @reset
        "Cancel": null

  reset: =>
    git.git "reset #{@commitID()}"

  confirmHardReset: ->
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@shortID()}?"
      detailedMessage: @message()
      buttons:
        "Cancel": null
        "Reset": @hardReset

  showCommit: =>
    if not @gitShowMessage?
      git.showObject @commitID(), (data) =>
        @gitShowMessage = decodeURIComponent(escape(data))
        @showCommit()
    else
      fs.writeFileSync path.join(git.getPath(), ".git/#{@commitID()}"), @gitShowMessage
      editor = atom.workspace.open(".git/#{@commitID()}")
      editor.then (e) =>
        @editor = e
        @editor.setGrammar atom.syntax.grammarForScopeName('diff.diff')
        @editor.buffer.once 'changed', =>
          @showCommitWrite()
        @editor.buffer.once 'destroyed', =>
          fs.removeSync path.join(git.getPath(), ".git/#{@commitID()}")

  showCommitWrite: =>
    return unless @editor? and @gitShowMessage?
    @editor.setText(@gitShowMessage)
    @editor.buffer.once 'changed', =>
      @showCommitWrite()

  hardReset: =>
    git.git "reset --hard #{@commitID()}"
