{CompositeDisposable} = require 'atom'
Repo = RepoView = ErrorView = null

module.exports =
  config:
    debug:
      title: 'Debug'
      description: 'Toggle debugging tools'
      type: 'boolean'
      default: false
      order: 1
    pre_commit_hook:
      title: 'Pre Commit Hook'
      description: 'Command to run for the pre commit hook'
      type: 'string'
      default: ''
      order: 2
    show_on_startup:
      title: 'Show on Startup'
      description: 'Check this if you want atomatigit to show up when Atom is loaded'
      type: 'boolean'
      default: false
      order: 3
    display_commit_comparisons:
      title: 'Display Commit Comparisons'
      description: 'Display how many commits ahead/behind your branches are'
      type: 'boolean'
      default: true
      order: 4

  repo: null
  repoView: null

  # Public: Package activation.
  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @insertCommands()
    @installPackageDependencies()
    @toggle() if atom.config.get('atomatigit.show_on_startup')

  # Public: Toggle the atomatigit pane.
  toggle: ->
    return @errorNoGitRepo() unless atom.project.getRepositories()[0]
    @loadClasses() unless Repo and RepoView
    @repo ?= new Repo()
    if !@repoView?
      @repoView = new RepoView(@repo)
      @repoView.InitPromise.then => @repoView.toggle()
    else
      @repoView.toggle()

  # Internal: Destroy atomatigit instance.
  deactivate: ->
    @repo?.destroy()
    @repoView?.destroy()
    @subscriptions.dispose()

  # Internal: Display error message if the project is no git repository.
  errorNoGitRepo: ->
    atom.notifications.addError('Project is no git repository!')

  # Internal: Register package commands with atom.
  insertCommands: ->
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atomatigit:toggle': => @toggle()

  # Internal: Load required classes on activation
  loadClasses: ->
    Repo     = require './models/repo'
    RepoView = require './views/repo-view'

  # Internal: Install all the package dependencies
  installPackageDependencies: ->
    return if atom.packages.getLoadedPackage('language-diff')
    require('atom-package-dependencies').install ->
      atom.notifications.addSuccess('Atomatigit: Dependencies installed correctly.', dismissable: true)
      atom.packages.activatePackage('language-diff')
