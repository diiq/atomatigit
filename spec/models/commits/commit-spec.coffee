base_require = require '../../spec_helper'
{Commit} = base_require 'models/commits'
{git} = base_require 'git'


describe "Commit", ->
  commit = null

  beforeEach ->
    commit = new Commit
      id: "12353252136"
      author:
        name: "Steve"
      message: "This is one line\n\nand this is another"

  describe ".commitID", ->
    it "returns the full id hash", ->
      expect(commit.commitID()).toEqual "12353252136"

  describe ".shortID", ->
    it "returns the first 6 characters of the hash", ->
      expect(commit.shortID()).toEqual "123532"

  describe ".reset", ->
    it "calls git reset with the commit id", ->
      git.git = jasmine.createSpy("git")
      commit.reset()
      expect(git.git).toHaveBeenCalledWith "reset 12353252136"

  describe ".hardReset", ->
    it "calls git reset with the commit id and a --hard flag", ->
      git.git = jasmine.createSpy("git")
      commit.hardReset()
      expect(git.git).toHaveBeenCalledWith "reset --hard 12353252136"

  describe ".confirmReset", ->
    it "confirms a reset, and calls .reset if confirmed", ->
      spyOn(atom, "confirm")
      commit.confirmReset()
      expect(atom.confirm).toHaveBeenCalledWith
        message: "Soft-reset head to 123532?"
        detailedMessage: "This is one line\n\nand this is another"
        buttons:
          "Reset": commit.reset
          "Cancel": null

  describe "confirmHardReset", ->
    it "confirms a hard reset, and calls .hardReset if confirmed", ->
      spyOn(atom, "confirm")
      commit.confirmHardReset()
      expect(atom.confirm).toHaveBeenCalledWith
        message: "Do you REALLY want to HARD-reset head to 123532?"
        detailedMessage: "This is one line\n\nand this is another"
        buttons:
          "Cancel": null
          "Reset": commit.hardReset
