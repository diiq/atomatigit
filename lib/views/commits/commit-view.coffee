{View} = require 'atom'

module.exports =
class CommitView extends View
  @content: (commit) ->
    @div class: "commit", click: "clicked", =>
      @div class: "id", "#{commit.shortID()}"
      @div class: "author-name", "(#{commit.authorName()})"
      @div class: "message text-subtle", "#{commit.shortMessage()}"

  initialize: (commit) ->
    @model = commit
    @model.on "change:selected", @showSelection

  beforeRemove: ->
    @model.off "change:selected", @showSelection

  clicked: =>
    @model.selfSelect()

  showSelection: =>
    @removeClass("selected")
    @addClass("selected") if @model.selectedP()
