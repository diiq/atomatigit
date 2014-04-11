Diff = require '../../lib/models/diff'

describe "Diff", ->
  describe "string methods", ->
    diff = new Diff "@@ "
    describe ".removeHeader", ->
      it "removes the first two lines of the diff", ->
        string = "multiline\nstring\n@@ with\ndouble-at\n@@ lines\n  "
        expectedResult = "@@ with\ndouble-at\n@@ lines\n  "
        expect(diff.removeHeader string).toEqual expectedResult

    describe ".splitChunks", ->
      it "chops up the diff on @@ -x/+x @@ lines", ->
        string = "@@ multiline\nstring\n@@ with\ndouble-at\n lines\n  "
        expectedResult = ["@@ multiline\nstring\n", "@@ with\ndouble-at\n lines\n  "]
        result = diff.splitChunks string
        expect(result.length).toBe 2
        expect(result[0]).toBe expectedResult[0]
        expect(result[1]).toBe expectedResult[1]

  describe "instance methods", ->
    string = ["--- a/lib/models/diff.coffee",
              "+++ b/lib/models/diff.coffee",
              "@@ -1,37 +1,29 @@",
              "-{Collection} = require 'backbone'",
              "+List = require './list'",
              "_ = require 'underscore'",
              "@@ -1,54 +1,33 @@",
              "DiffChunk = require './diff-chunk'",
              "-ListModel = require './list-model'"].join "\n"
    diff = null
    beforeEach ->
      diff = new Diff string

    describe ".constructor", ->
      it "populates the collection with chunks", ->
        expect(diff.models.length).toBe 2

    describe ".chunks", ->
      it "is an alias of .models", ->
        expect(diff.chunks()).toBe diff.models
