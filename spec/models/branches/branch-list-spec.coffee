base_require = require '../../spec_helper'
{BranchList, Branch} = base_require 'models/branches'
{git} = base_require 'git'

describe "BranchList", ->
  remote_branches = [{
      name: "remote"
      commit:
        id: "3r73345735"
        message: "Some\n\n and more"}]

  list = null
  beforeEach ->
    list = new BranchList

  describe ".reload", ->
    it "calls git.branches with .addLocals as a callback", ->
      git.branches = jasmine.createSpy "branches"
      list.reload()
      expect(git.branches).toHaveBeenCalledWith(list.addLocals)

  describe ".addLocals", ->
    branches = [{
        name: "a local"
        commit:
          id: "3r73345735"
          message: "Some\n\n and more"}]

    beforeEach ->
      git.remotes = jasmine.createSpy "remoteBranches"

    it "poulates local branches", ->
      list.addLocals(branches)
      expect(list.local().length).toBe 1

    it "calls for remote branches with addRemotes as a callback", ->
      list.addLocals(branches)
      expect(git.remotes).toHaveBeenCalledWith(list.addRemotes)

  describe ".addRemotes", ->
    branches = [{
        name: "a remote"
        commit:
          id: "3r73345735"
          message: "Some\n\n and more"}]

    it "poulates remote branches", ->
      list.addRemotes branches
      expect(list.remote().length).toBe 1

    it "re-selects", ->
      spyOn(list, "select")
      list.addRemotes branches
      expect(list.select).toHaveBeenCalled

  describe "sublists", ->
    locals = [{
        name: "local"
        commit:
          id: "3r73345735"
          message: "Some\n\n and more"}]
    remotes = [{
        name: "a remote"
        commit:
          id: "3r73345735"
          message: "Some\n\n and more"}]

    beforeEach ->
      list.addLocals locals
      list.addRemotes remotes

    describe ".local", ->
      it "returns local branches", ->
        expect(list.local()[0].name()).toEqual "local"

    describe ".remote", ->
      it "returns remote branches", ->
        expect(list.remote()[0].name()).toEqual "a remote"
