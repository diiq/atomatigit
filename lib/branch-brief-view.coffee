{View} = require 'atom'

module.exports =
class BranchBriefView extends View
  @content: ->
    @div class: "branch-brief" =>
      @span class: "name", outlet: "name"
      @span class: "commit", outlet: "commit"

  initialize: (head) ->
    @name.html("#{head.name}")
    @commit.html("(#{head.commit.id} -- #{head.commit.message}")
