base_require = require '../../spec_helper'
{Branch} = base_require 'models/branches'
{git} = base_require 'git'

describe "Branch", ->
  branch = ""
  beforeEach ->
    branch = new Branch
      name: "name"
      commit:
        id: "123451626236"
        message: "THis is short\n\n and this is more"

  describe ".name" , ->
    it "returns the name", ->
      expect(branch.name()).toEqual "name"

  describe ".localName", ->
    it "is an alias of .name", ->
      expect(branch.localName()).toEqual "name"

  describe ".commit", ->
    it "returns a commit model", ->
      expect(branch.commit().shortID()).toBe "123451"

  describe ".unpushed", ->
    it "returns false", ->
      expect(branch.unpushed()).toBe false

  describe ".kill", ->
    it "confirms and then deletes the branch", ->
      spyOn(atom, "confirm")
      branch.kill()
      expect(atom.confirm).toHaveBeenCalledWith
        message: "Delete branch name?"
        buttons:
          "Delete": branch.delete
          "Cancel": null

  describe ".checkout", ->
    it "calls git checkout with the local name of the branch", ->
      git.git = jasmine.createSpy("git")
      branch.checkout()
      expect(git.git).toHaveBeenCalledWith "checkout name"
