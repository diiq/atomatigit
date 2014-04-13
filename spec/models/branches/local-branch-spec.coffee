require '../../spec_helper'
{LocalBranch} = require __base + 'models/branches'
{git} = require __base + 'git'

describe "LocalBranch", ->
  branch = ""
  beforeEach ->
    branch = new LocalBranch
      name: "name"
      unpushed: true
      commit:
        id: "123451626236"
        message: "This is short\n\n and this is more"

  describe ".unpushed" , ->
    it "returns true if unpushed", ->
      expect(branch.unpushed()).toBe true

  describe ".delete", ->
    it "calls git branch -D", ->
      git.git = jasmine.createSpy("git")
      branch.delete()
      expect(git.git).toHaveBeenCalledWith "branch -D name"

  describe ".remoteName", ->
    it "returns an empty string, for now", ->
      expect(branch.remoteName()).toBe ""

  describe ".checkout", ->
    it "calls git checkout", ->
      git.git = jasmine.createSpy("git")
      branch.checkout()
      expect(git.git).toHaveBeenCalledWith "checkout name"

  describe ".push", ->
    it "increments the task counter, and calls git push", ->
      git.incrementTaskCounter = jasmine.createSpy "incrementTaskCounter"
      git.decrementTaskCounter = jasmine.createSpy "dencrementTaskCounter"
      git.remotePush = jasmine.createSpy("remotePush")
      branch.push()
      expect(git.incrementTaskCounter).toHaveBeenCalled()
      expect(git.remotePush).toHaveBeenCalledWith "origin name", git.decrementTaskCounter
