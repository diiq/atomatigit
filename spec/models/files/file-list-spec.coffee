base_require = require '../../spec_helper'
{FileList} = base_require 'models/files'
{git} = base_require 'git'


describe "FileList", ->
  statusList =
    untracked: [{path: "a.bar", status: {}}, {path: "b.bar", status: {}}]
    unstaged: [{path: "b.bar", status: {tracked: true}}]
    staged: [{path: "c.bar", status: {tracked: true, staged: true}}]

  list = null
  beforeEach ->
    git.diff = jasmine.createSpy("diff")
    list = new FileList
    list.populate statusList

  describe ".populate", ->
    it "populates with tracked, untracked, and staged files", ->
      expect(list.models.length).toBe 4

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
      expect(list.untracked().length).toBe 2
      expect(list.untracked()[0].path()).toEqual "a.bar"

  describe ".newPaths", ->
    it "returns the subset of paths that don't have associated files", ->
      paths = [{path: "b.bar"}, {path: "c.bar"}]
      new_paths = list.newPaths(paths, list.untracked())
      expect(new_paths.length).toEqual 1
      expect(new_paths[0].path).toEqual "c.bar"

  describe ".missingFiles", ->
    it "returns the subset of files that don't appear in paths", ->
      paths = [{path: "b.bar"}, {path: "c.bar"}]
      missing_files = list.missingFiles(paths, list.untracked())
      expect(missing_files.length).toEqual 1
      expect(missing_files[0].path()).toEqual "a.bar"

  describe ".stillThereFiles", ->
    it "returns the subset of files that appear in paths", ->
      paths = [{path: "b.bar"}, {path: "c.bar"}]
      stillThereFiles = list.stillThereFiles(paths, list.untracked())
      expect(stillThereFiles.length).toEqual 1
      expect(stillThereFiles[0].path()).toEqual "b.bar"
