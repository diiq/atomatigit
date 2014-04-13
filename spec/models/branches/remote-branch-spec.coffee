base_require = require '../../spec_helper'
{RemoteBranch} = base_require 'models/branches'
{git} = base_require 'git'

describe "RemoteBranch", ->
  branch = ""
  beforeEach ->
    branch = new RemoteBranch
      name: "origin/name"
      unpushed: true
      commit:
        id: "123451626236"
        message: "This is short\n\n and this is more"

  describe ".delete", ->
    it "calls git push -f remoteName :localName", ->
      git.git = jasmine.createSpy("git")
      branch.delete()
      expect(git.git).toHaveBeenCalledWith "push -f origin :name"

  describe ".remoteName", ->
    it "the part before the /", ->
      expect(branch.remoteName()).toBe "origin"

  describe ".localName", ->
    it "the part after the /", ->
      expect(branch.localName()).toBe "name"
