##
# This

{View} = require 'atom'

module.exports =
class BranchBriefView extends View
  @content: ->
    @div class: "branch-brief-view", =>
      @div class: "name", outlet: "name"
      @div class: "commit", outlet: "commit"

  refresh: (head) ->
    @name.html("#{head.name}")
    @commit.html("(#{head.commit.id.substr(0, 6)}: #{head.commit.message})")
