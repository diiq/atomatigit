base_require = require '../../spec_helper'
{UntrackedFile} = base_require 'models/files'
{git} = base_require 'git'

shell = require 'shell'

describe "UntrackedFile", ->
  file = null
  beforeEach ->
    file = new UntrackedFile
      path: "execter/foo.bar"

  describe ".sort_value" , ->
    it "is 0", ->
      expect(file.sort_value).toBe 0

  describe ".moveToTrash", ->
    it "calls shell.moveItemToTrash with its own path", ->
      spyOn shell, "moveItemToTrash"
      git.trigger = jasmine.createSpy("trigger")
      git.path = "foo"
      file.moveToTrash()
      expect(shell.moveItemToTrash).toHaveBeenCalledWith("foo/" + file.path())

  describe ".kill", ->
    it "calls atom.confirm", ->
      spyOn atom, "confirm"
      file.kill()
      expect(atom.confirm).toHaveBeenCalled()
      expect(atom.confirm.mostRecentCall.args[0].message).toEqual 'Move "execter/foo.bar" to trash?'
      expect(atom.confirm.mostRecentCall.args[0].buttons["Trash"]).toBe file.moveToTrash
