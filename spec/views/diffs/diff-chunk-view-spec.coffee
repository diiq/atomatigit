base_require = require '../../spec_helper'
{DiffChunk} = base_require 'models/diffs'
{DiffChunkView} = base_require 'views/diffs'

describe "DiffChunkView", ->
  string = ["@@ -1,43 +1,28 @@",
           "",
           "-{Collection} = require 'backbone'",
           "DiffLine = require './diff-line'",
           "+ListItem = require './list-item'"
           "",
           ""].join("\n")
  model = view = null

  beforeEach ->
    model = new DiffChunk chunk: string
    view = new DiffChunkView model

  describe ".initialize", ->
    it "adds a DiffLineView for each line", ->
      expect(view.children().length).toBe 3

  describe ".clicked", ->
    it "calls model.selfSelect", ->
      spyOn(model, "selfSelect")
      view.clicked()
      expect(model, "selfSelect").toHaveBeenCalled

  describe ".showSelection", ->
    it "adds selected class if model is selected", ->
      model.select()
      view.showSelection()
      expect(view.hasClass "selected").toBe true

    it "removes selected class if model is not selected", ->
      model.deselect()
      view.showSelection()
      expect(view.hasClass "selected").toBe false
