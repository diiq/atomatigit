_    = require 'lodash'
fs   = require 'fs-plus'
path = require 'path'

git       = require '../../git'
ListItem  = require '../list-item'
ErrorView = require '../../views/error-view'

class Commit extends ListItem
  defaults:
    showMessage: null
    author: null
    id: null
    message: null

  # Public: Constructor.
  #
  # gitCommit - The promisedgit commit object as {Object}.
  initialize: (gitCommit) ->
    super()
    if not _.isString(gitCommit) and _.isObject(gitCommit)
      @set 'author', gitCommit.author
      @set 'id', gitCommit.ref
      @set 'message', gitCommit.message

  # Public: Handle unicode characters.
  #
  # s - The string to handle as {String}.
  #
  # Returns the transformed string as {String}.
  unicodify: (str) ->
    try str = decodeURIComponent(escape(str))
    str

  # Public: Return the commit id.
  #
  # Returns the id as {String}.
  commitID: =>
    @get 'id'

  # Public: Return the short id.
  #
  # Returns the short id as {String}.
  shortID: =>
    @commitID()?.substr(0, 6)

  # Public: Return the author name.
  #
  # Returns the author name as {String}.
  authorName: =>
    @unicodify @get('author')?.name

  # Public: Return the commit message.
  #
  # Returns the commit message as {String}.
  message: =>
    @unicodify (@get('message') or '\n')

  # Public: Return the head line of the commit message.
  #
  # Returns the commit head line as {String}.
  shortMessage: =>
    @message().split('\n')[0]

  # Public: open -> soft reset to this commit.
  open: =>
    @confirmReset()

  # Public: Ask the user for confirmation to soft-reset to this commit.
  confirmReset: =>
    atom.confirm
      message: "Soft-reset head to #{@shortID()}?"
      detailedMessage: @message()
      buttons:
        'Reset': @reset
        'Cancel': null

  # Public: Ask the user for confirmation to hard-reset to this commit.
  confirmHardReset: =>
    atom.confirm
      message: "Do you REALLY want to HARD-reset head to #{@shortID()}?"
      detailedMessage: @message()
      buttons:
        'Cancel': null
        'Reset': @hardReset

  # Internal: Reset to this commit.
  reset: =>
    git.reset @commitID()
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Hard reset to this commit.
  hardReset: =>
    git.reset @commitID(), {hard: true}
    .then => @trigger 'update'
    .catch (error) -> new ErrorView(error)

  # Public: Show this commit.
  showCommit: =>
    if not @has('showMessage')
      git.show @commitID(), format: 'full'
      .then (data) =>
        @set('showMessage', @unicodify(data))
        @showCommit()
      .catch (error) -> new ErrorView(error)
    else
      gitPath = atom.project?.getRepositories()[0]?.getPath() or atom.project?.getPath()
      diffPath = path.join(gitPath, ".git/#{@commitID()}")
      fs.writeFileSync diffPath, @get('showMessage')
      atom.workspace.open(diffPath).then (editor) ->
        grammar = atom.grammars.grammarForScopeName('source.diff')
        editor.setGrammar(grammar) if grammar
        editor.buffer.onDidDestroy ->
          fs.removeSync(diffPath)

module.exports = Commit
