require '../../spec_helper'
{FileList} = require __base + 'models/files'
{git} = require __base + 'git'


describe "FileList", ->
  statusList =
    untracked: [{path: "a.bar", status: {}}]
    unstaged: [{path: "b.bar", status: {tracked: true}}]
    staged: [{path: "c.bar", status: {tracked: true, staged: true}}]

  list = null
  beforeEach ->
    git.diff = jasmine.createSpy("diff")
    list = new FileList
    list.populate statusList

  describe ".populate", ->
    it "populates with tracked, untracked, and staged files", ->
      expect(list.models.length).toBe 3

  describe ".comparator", ->
    it "takes a file and returns the file's sort value", ->
      file = {sort_value: 5}
      expect(list.comparator file).toBe 5

  describe ".staged", ->
    it "returns only staged files", ->
      expect(list.staged().length).toBe 1
      expect(list.staged()[0].path()).toEqual "c.bar"

  describe ".unstaged", ->
    it "returns only unstaged files", ->
      expect(list.unstaged().length).toBe 1
      expect(list.unstaged()[0].path()).toEqual "b.bar"

  describe ".untracked", ->
    it "returns only untracked files", ->
      expect(list.untracked().length).toBe 1
      expect(list.untracked()[0].path()).toEqual "a.bar"
