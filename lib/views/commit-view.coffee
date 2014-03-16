{View} = require 'atom'
DiffView = require './diff-view'

module.exports =
class FileView extends View
  @content: (commit) ->
    @div class: "commit", click: "clicked", =>
      @div class: "id", "#{commit.short_id()}"
      @div class: "message", "(#{commit.short_commit_message()})"

  initialize: (commit) ->
    @model = commit
    @model.on "change:selected", @select

  beforeRemove: ->
    @model.off "change:selected", @select

  clicked: ->
    @model.self_select()

  select: =>
    @removeClass("selected")
    @addClass("selected") if @model.selected()
