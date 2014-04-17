base_require = require '../../spec_helper'
{DiffChunk} = base_require 'models/diffs'

describe "DiffChunk", ->
  describe "string methods", ->
    chunk = new DiffChunk chunk: ""
    describe ".deleteTrailingWhitespace", ->
      it "deletes any whitespace at the end of the chunk", ->
        string = "multiline\nstring with whitespace \n    \n  "
        expectedResult = "multiline\nstring with whitespace"
        expect(chunk.deleteTrailingWhitespace string).toEqual expectedResult

    describe ".deleteInitialWhitespace", ->
      it "deletes any whitespace at the beginning of the chunk, up to the last newline", ->
        string = "   \n  multiline\nstring with whitespace"
        expectedResult = "  multiline\nstring with whitespace"
        expect(chunk.deleteInitialWhitespace string).toEqual expectedResult

    describe ".deleteFirstLine", ->
      it "deletes the first line", ->
        string = "multiline\nstring with \nwhitespace"
        expectedResult = "string with \nwhitespace"
        expect(chunk.deleteFirstLine string).toEqual expectedResult

  describe ".initialize", ->
    it "populates .lines with DiffLines", ->
      string = ["@@ -1,43 +1,28 @@",
               "",
               "-{Collection} = require 'backbone'",
               "DiffLine = require './diff-line'",
               "+ListItem = require './list-item'"
               "",
               ""].join("\n")
      chunk = new DiffChunk chunk: string
      expect(chunk.lines.length).toBe 3
