base_require = require '../../spec_helper'
{FileList} = base_require 'models/files'
{FileListView} = base_require 'views/files'
{git} = base_require 'git'

describe "FileListView", ->
  statusList =
    untracked: [{path: "a.bar", status: {}}]
    unstaged: [{path: "b.bar", status: {tracked: true}}]
    staged: [{path: "c.bar", status: {tracked: true, staged: true}}]

  model = view = null
  beforeEach ->
    git.diff = jasmine.createSpy("diff")
    model = new FileList
    view = new FileListView model
    model.populate statusList

  describe ".repopulateUntracked", ->
    it "fills in the untracked dom element", ->
      view.untracked.empty()
      view.repopulateUntracked()
      expect(view.untracked.children().length).toBe 1

  describe ".repopulateUnstaged", ->
    it "fills in the unstaged dom element", ->
      view.unstaged.empty()
      view.repopulateUnstaged()
      expect(view.unstaged.children().length).toBe 1

  describe ".repopulateStaged", ->
    it "fills in the staged dom element", ->
      view.staged.empty()
      view.repopulateStaged()
      expect(view.staged.children().length).toBe 1
