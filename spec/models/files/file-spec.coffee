base_require = require '../../spec_helper'
{File} = base_require 'models/files'
{git} = base_require 'git'


describe "File", ->
  file = "poop"
  beforeEach ->
    file = new File
      path: "execter/foo.bar"

  describe ".path" , ->
    it "returns the path", ->
      expect(file.path()).toEqual "execter/foo.bar"

  describe ".showDiffP", ->
    it "returns true if we should show the diff", ->
      file.set diff: true
      expect(file.showDiffP()).toBe true

    it "returns false if we shouldn't show the diff", ->
      file.set diff: false
      expect(file.showDiffP()).toBe false

  describe ".diff", ->
    it "returns the sublist, which is a diff", ->
      expect(file.diff()).toBe file.sublist

  describe ".stage", ->
    it "stages the file using git.add", ->
      git.add = jasmine.createSpy("add")
      file.stage()
      expect(git.add).toHaveBeenCalled()
      expect(git.add.mostRecentCall.args[0]).toBe file.path()

  describe ".setDiff", ->
    string = ["--- a/lib/models/diff.coffee",
              "+++ b/lib/models/diff.coffee",
              "@@ -1,37 +1,29 @@",
              "-{Collection} = require 'backbone'",
              "+List = require './list'",
              "_ = require 'underscore'",
              "@@ -1,54 +1,33 @@",
              "DiffChunk = require './diff-chunk'",
              "-ListModel = require './list-model'"].join "\n"
    it "creates a new sublist based on the diff object", ->
      file.setDiff diff: string
      expect(file.diff().chunks().length).toBe 2

  describe ".toggleDiff", ->
    it "toggles the value of .showDiffP", ->
      expect(file.showDiffP()).toBe false
      file.toggleDiff()
      expect(file.showDiffP()).toBe true
      file.toggleDiff()
      expect(file.showDiffP()).toBe false

  describe ".open", ->
    it "opens the file in an atom editor", ->
      atom.workspaceView = jasmine.createSpyObj("workspaceView", ["open"])
      file.open()
      expect(atom.workspaceView.open).toHaveBeenCalledWith(file.path())
