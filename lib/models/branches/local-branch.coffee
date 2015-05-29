git        = require '../../git'
Branch     = require './branch'
ErrorView  = require '../../views/error-view'
OutputView = require '../../views/output-view'

# Public: LocalBranch class that extends the {Branch} prototype.
class LocalBranch extends Branch

  remote: false
  local: true

  # Public: Constructor
  initialize: ->
    @compareCommits() if atom.config.get('atomatigit.display_commit_comparisons')

  # Internal: Compares this branches commits and stores it as {String}
  #
  # Returns {Promise}
  compareCommits: =>
    @comparison = comparison = ''
    name = @localName().trim()
    @getTrackingBranch(name).then =>
      if @tracking_branch is ''
        @comparison = 'No upstream configured'
        return @trigger 'comparison-loaded'
      tracking_branch = @tracking_branch
      git.cmd("rev-list --count #{name}@{u}..#{name}").then (output) =>
        number = +output.trim()
        comparison = @getComparisonString number, 'ahead of', tracking_branch if number isnt 0
        git.cmd("rev-list --count #{name}..#{name}@{u}").then (output) =>
          number = +output.trim()
          if number isnt 0
            comparison += '<br>' if comparison isnt ''
            comparison += @getComparisonString number, 'behind', tracking_branch
          else if comparison is ''
            comparison = "Up-to-date with #{tracking_branch}"
          @comparison = comparison
          @trigger 'comparison-loaded'

  # Internal: Stores the tracking branch in @tracking_branch as {String}
  #
  # Returns {Promise}
  getTrackingBranch: (name) =>
    @tracking_branch = ''
    git.cmd("config branch.#{name}.remote").then (output) =>
      output = output.trim()
      remote = "#{output}/"
      git.cmd("config branch.#{name}.merge").then (output) =>
        @tracking_branch = remote + output.trim().replace('refs/heads/', '')
    .catch -> '' # Throws when there's no upstream configured. We handle that elsewhere.

  # Internal: Formats the commit comparison string
  #
  # Returns {String}
  getComparisonString: (number, ahead_of_or_behind, tracking_branch) ->
    str = "#{number} commit"
    str += "s" unless number is 1
    str += " #{ahead_of_or_behind} "
    str += tracking_branch

  # Public: Return the 'unpushed' property.
  #
  # Returns the property as {String}.
  unpushed: =>
    @get 'unpushed'

  # Public: Delete the branch.
  delete: =>
    git.cmd 'branch', {D: true}, @getName()
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # TODO tracking branch or something?
  remoteName: -> ''

  # Public: Checkout the branch.
  #
  # callback - The callback as {Function}.
  checkout: (callback) =>
    git.checkout @localName()
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Push the branch to remote.
  #
  # remote - The remote to push to as {String}.
  push: (remote='origin') =>
    git.cmd 'push', [remote, @getName()]
    .then =>
      @trigger 'update'
      new OutputView('Pushing to remote repository successful')
    .catch (error) -> new ErrorView(error)

module.exports = LocalBranch
