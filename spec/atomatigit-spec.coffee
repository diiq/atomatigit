path = require 'path'
fs = require 'fs-plus'
temp = require 'temp'
Repo = require '../lib/models/repo'
{UnstagedFile} = require '../lib/models/files'
RepoView = require '../lib/views/repo-view'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Atomatigit", ->
  [workspaceElement, activationPromise, repo, repoView] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    projectPath = temp.mkdirSync('atomatigit-spec-')
    fs.copySync(path.join(__dirname, 'fixtures', 'working-dir'), projectPath)
    fs.moveSync(path.join(projectPath, 'git.git'), path.join(projectPath, '.git'))
    atom.project.setPaths([projectPath])

    spyOn(UnstagedFile::, 'loadDiff').andCallFake( -> )

    activationPromise = atom.packages.activatePackage('atomatigit').then ({mainModule}) ->
      repo = new Repo

      spyOn(repo, 'reload').andCallFake( ->
        new Promise((resolve, reject) -> resolve())
      )

      repoView = new RepoView(repo)
      mainModule.repo = repo
      mainModule.repoView = repoView

    waitsForPromise ->
      activationPromise

  describe 'atomatigit:toggle', ->
    it 'hides and shows the view', ->
      runs ->
        expect(workspaceElement.querySelector('.atomatigit')).not.toExist()
        atom.commands.dispatch workspaceElement, 'atomatigit:toggle'
        expect(workspaceElement.querySelector('.atomatigit')).toExist()

        atomatigitElement = workspaceElement.querySelector('.atomatigit')
        expect(atomatigitElement).toExist()
        expect(atomatigitElement).toBeVisible()

        atom.commands.dispatch workspaceElement, 'atomatigit:toggle'
        expect(workspaceElement.querySelector('.atomatigit')).not.toExist()
        expect(atomatigitElement).not.toBeVisible()

  describe 'atomatigit:branches', ->
    it 'switch active view', ->
      runs ->
        atom.commands.dispatch workspaceElement, 'atomatigit:toggle'
        expect(workspaceElement.querySelector('.atomatigit')).toExist()
        atomatigitElement = workspaceElement.querySelector('.atomatigit')

        branchListElement = workspaceElement.querySelector('.branch-list-view')
        expect(branchListElement).toExist()
        expect(branchListElement).not.toBeVisible()
        atom.commands.dispatch atomatigitElement, 'atomatigit:branches'
        expect(branchListElement).toBeVisible()

  describe 'atomatigit:commit-log', ->
    it 'switch active view', ->
      runs ->
        atom.commands.dispatch workspaceElement, 'atomatigit:toggle'
        expect(workspaceElement.querySelector('.atomatigit')).toExist()
        atomatigitElement = workspaceElement.querySelector('.atomatigit')

        commitListElement = workspaceElement.querySelector('.commit-list-view')
        expect(commitListElement).toExist()
        expect(commitListElement).not.toBeVisible()
        atom.commands.dispatch atomatigitElement, 'atomatigit:commit-log'
        expect(commitListElement).toBeVisible()
