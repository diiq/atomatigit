DiffLine = require '../../lib/models/diff-line'
DiffLineView = require '../../lib/views/diff-line-view'

describe "DiffView", ->
  describe ".initialize", ->
    it "adds context class if it's a context line", ->
      model = new DiffLine line: "this is it"
      view = new DiffLineView model
      expect(view.hasClass("context")).toBe true

    it "adds addition class if it's an addition line", ->
      model = new DiffLine line: "+ this is it"
      view = new DiffLineView model
      expect(view.hasClass("addition")).toBe true

    it "adds subtraction class if it's a subtraction line", ->
      model = new DiffLine line: "- this is it"
      view = new DiffLineView model
      expect(view.hasClass("subtraction")).toBe true

    it "always has a diff-line class", ->
      model = new DiffLine line: "- this is it"
      view = new DiffLineView model
      expect(view.hasClass("diff-line")).toBe true

    it "contains the line's markup string", ->
      model = new DiffLine line: "- this is it"
      view = new DiffLineView model
      expect(view.html()).toEqual model.markup()
