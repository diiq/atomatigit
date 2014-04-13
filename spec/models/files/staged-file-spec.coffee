base_require = require '../../spec_helper'
{StagedFile} = base_require 'models/files'
{git} = base_require 'git'


describe "StagedFile", ->
  file = null
  beforeEach ->
    git.diff = jasmine.createSpy("diff")
    file = new StagedFile
      path: "execter/foo.bar"

  describe ".sort_value" , ->
    it "is 2", ->
      expect(file.sort_value).toBe 2

  describe ".unstage", ->
    it "calls git reset with its own path", ->
      git.git = jasmine.createSpy("git")
      file.unstage()
      expect(git.git).toHaveBeenCalledWith("reset HEAD #{file.path()}")

  describe ".loadDiff", ->
    it "calls git reset with its own path", ->
      file.loadDiff()
      expect(git.diff).toHaveBeenCalledWith(file.path(), file.setDiff, flags: "--staged")

  describe "discardAllChanges", ->
    it "calls git reset with its own path", ->
      git.git = jasmine.createSpy("git")
      file.discardAllChanges()
      expect(git.git).toHaveBeenCalled()
      expect(git.git.mostRecentCall.args[0]).toEqual "reset HEAD execter/foo.bar"

  describe ".kill", ->
    it "calls atom.confirm", ->
      spyOn atom, "confirm"
      file.kill()
      expect(atom.confirm).toHaveBeenCalled()
      expect(atom.confirm.mostRecentCall.args[0].message).toEqual 'Discard all changes to "execter/foo.bar"?'
      expect(atom.confirm.mostRecentCall.args[0].buttons["Discard"]).toBe file.discardAllChanges
