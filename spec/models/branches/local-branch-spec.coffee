base_require = require '../../spec_helper'
{LocalBranch} = base_require 'models/branches'
{git} = base_require 'git'

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
    it "calls git push", ->
      git.remotePush = jasmine.createSpy("remotePush")
      branch.push()
      expect(git.remotePush).toHaveBeenCalledWith "origin name"
