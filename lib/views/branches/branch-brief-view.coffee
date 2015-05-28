{View} = require 'atom-space-pen-views'

# Hash to store commit comparisons based on branch names
branch_comparisons = {}

# Public: Visual representation of a brief branch.
class BranchBriefView extends View
  @content: ->
    @div class: 'branch-brief-view', mousedown: 'clicked', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'
      @div class: 'comparison', outlet: 'comparison'

  # Public: Constructor.
  initialize: (@model) ->
    @repaint()

  # Public: 'attached' hook.
  attached: =>
    @model.on 'change:selected', @showSelection
    @model.on 'comparison-loaded', @updateComparison if @model.local

  # Public: 'detached' hook.
  detached: =>
    @model.off 'change:selected', @showSelection
    @model.off 'comparison-loaded', @updateComparison if @model.local

  # Public: 'clicked' handler.
  clicked: =>
    @model.selfSelect()

  # Internal: Update comparison string
  updateComparison: =>
    return unless atom.config.get('atomatigit.display_commit_comparisons')
    name = @model.getName()
    comparison = @model.comparison || branch_comparisons[name]
    branch_comparisons[name] = comparison if comparison isnt ''
    @comparison.html(comparison || 'Calculating...')

  # Public: Trigger a repaint.
  repaint: =>
    @name.html("#{@model.getName()}")
    @commit.html("(#{@model.commit().shortID()}: #{@model.commit().shortMessage()})")
    @updateComparison() if @model.local

    @commit.removeClass 'unpushed'
    if @model.unpushed()
      @commit.addClass 'unpushed'

    @showSelection()

  # Public: Show the selection.
  showSelection: =>
    @removeClass('selected')
    @addClass('selected') if @model.isSelected()

module.exports = BranchBriefView
