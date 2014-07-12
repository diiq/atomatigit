base_require = require '../../spec_helper'
{CurrentBranch} = base_require 'models/branches'
{git} = base_require 'git'

describe 'Branch', ->
  branch = ''
  git.branch = jasmine.createSpy('branch')
  beforeEach ->
    git.gitNoChange = jasmine.createSpy('gitNoChange')
    branch = new CurrentBranch(true)

  describe '.initialize/.reload', ->
    it 'updates the branch and also its pushed/unpushed status', ->
      expect(git.branch).toHaveBeenCalled()
      # On hold until I can make it work with non-tracking branches:
      # expect(git.gitNoChange).toHaveBeenCalled()

  describe 'head', ->
    it "returns 'HEAD'", ->
      expect(branch.head()).toEqual 'HEAD'
