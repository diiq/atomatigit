{View} = require 'atom'

# Hash to store commit comparisons based on branch names
branch_comparisons = {}

# Public: Visual representation of the current branch.
class CurrentBranchView extends View
  @content: ->
    @div class: 'current-branch-view', =>
      @div class: 'name', outlet: 'name'
      @div class: 'commit', outlet: 'commit'
      @div class: 'comparison', outlet: 'comparison'

  # Public: Constructor.
  initialize: (@model) ->
    @model.on 'repaint', @repaint
    @model.on 'comparison-loaded', @updateComparison
    @repaint()

  # Public: 'beforeRemove' handler.
  beforeRemove: =>
    @model.off 'repaint', @repaint
    @model.off 'comparison-loaded', @updateComparison

  # Internal: Update comparison string
  updateComparison: =>
    return @comparison.html('') unless atom.config.get('atomatigit.display_commit_comparisons')
    name = @model.getName()
    comparison = @model.comparison || branch_comparisons[name]
    branch_comparisons[name] = comparison if comparison isnt ''
    @comparison.html(comparison || 'Calculating...')

  # Public: Trigger a repaint.
  repaint: =>
    @name.html("#{@model.name}")
    @commit.html("(#{@model.commit.shortID?()}: #{@model.commit.shortMessage?()})")
    @updateComparison()

    @commit.removeClass 'unpushed'
    @commit.addClass 'unpushed' if @model.unpushed()

module.exports = CurrentBranchView
