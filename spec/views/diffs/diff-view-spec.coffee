base_require = require '../../spec_helper'
{Diff} = base_require 'models/diffs'
{DiffView} = base_require 'views/diffs'

describe "DiffView", ->
  string = ["--- a/lib/models/diff.coffee",
            "+++ b/lib/models/diff.coffee",
            "@@ -1,37 +1,29 @@",
            "-{Collection} = require 'backbone'",
            "+List = require './list'",
            "_ = require 'underscore'",
            "@@ -1,54 +1,33 @@",
            "DiffChunk = require './diff-chunk'",
            "-ListModel = require './list-model'"].join "\n"
  model = view = null
  beforeEach ->
    model = new Diff diff: string
    view = new DiffView model

  describe ".initialize", ->
    it "shows the list of chunks", ->
      expect(view.children().length).toBe 2
