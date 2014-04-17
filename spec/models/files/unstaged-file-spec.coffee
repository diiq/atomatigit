base_require = require '../../spec_helper'
{UnstagedFile} = base_require 'models/files'
{git} = base_require 'git'


describe "UnstagedFile", ->
  file = null
  beforeEach ->
    git.diff = jasmine.createSpy("diff")
    file = new UnstagedFile
      path: "execter/foo.bar"

  describe ".sort_value" , ->
    it "is 1", ->
      expect(file.sort_value).toBe 1

  describe ".checkout", ->
    it "resets file by calling git checkout with its own path", ->
      git.git = jasmine.createSpy("git")
      file.checkout()
      expect(git.git).toHaveBeenCalledWith("checkout execter/foo.bar")

  describe ".kill", ->
    it "calls atom.confirm", ->
      spyOn atom, "confirm"
      file.kill()
      expect(atom.confirm).toHaveBeenCalled()
      expect(atom.confirm.mostRecentCall.args[0].message).toEqual 'Discard unstaged changes to "execter/foo.bar"?'
      expect(atom.confirm.mostRecentCall.args[0].buttons["Discard"]).toBe file.checkout

  describe ".loadDiff", ->
    it "calls git diff with its own path", ->
      file.loadDiff()
      expect(git.diff).toHaveBeenCalledWith("execter/foo.bar", file.setDiff)
