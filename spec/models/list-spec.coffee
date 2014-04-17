base_require = require '../spec_helper'
ListItem = base_require 'models/list-item'
List = base_require 'models/list'

class AModel extends ListItem

class AList extends List
  model: AModel

describe "List", ->
  list = null

  beforeEach ->
    list = new AList [{char: "a"},
                      {char: "b"},
                      {char: "c"},
                      {char: "d"},
                      {char: "e"},
                      {char: "f"},
                      {char: "g"},
                      {char: "h"},
                      {char: "i"}]

  describe ".selection", ->
    it "returns the selected model", ->
      list.selected_index = 3
      expect(list.selection().get "char").toBe "d"

  describe ".select", ->
    it "sets selection to the model at index i if i is in range", ->
      list.select 4
      expect(list.selection().get "char").toBe "e"

    it "sets selection to the last model if i is too big", ->
      list.select 40
      expect(list.selection().get "char").toBe "i"

    it "sets selection to the first model if i is too small", ->
      list.select -10
      expect(list.selection().get "char").toBe "a"

    it "deselects the old current model", ->
      list.select 4
      spyOn(list.at(4), "deselect")
      list.select 8
      expect(list.at(4), "deselect").toHaveBeenCalled

    it "selects the new current model", ->
      list.select 4
      spyOn(list.at(8), "select")
      list.select 8
      expect(list.at(8), "select").toHaveBeenCalled

    it "returns true if the selected index has changed", ->
      list.select 4
      expect(list.select 8).toBe true

    it "returns false if the selected index has not changed", ->
      list.select 4
      expect(list.select 4).toBe false

  describe ".next", ->
    it "advances the selection", ->
      list.select 2
      list.next()
      expect(list.selection().get "char").toBe "d"

    it "doesn't advance if the current selection doesn't allowNext", ->
      list.select 2
      spyOn(list.selection(), "allowNext").andReturn(false)
      list.next()
      expect(list.selection().get "char").toBe "c"

    it "returns false if the current selection doesn't allowNext", ->
      list.select 2
      spyOn(list.selection(), "allowNext").andReturn(false)
      expect(list.next()).toBe false

    it "returns false if the current selection is the last", ->
      list.select 40
      expect(list.next()).toBe false

    it "returns true if the selection has advanced", ->
      list.select 2
      expect(list.next()).toBe true


  describe ".previous", ->
    it "advances the selection", ->
      list.select 2
      list.previous()
      expect(list.selection().get "char").toBe "b"

    it "doesn't advance if the current selection doesn't allowPrevious", ->
      list.select 2
      spyOn(list.selection(), "allowPrevious").andReturn(false)
      list.previous()
      expect(list.selection().get "char").toBe "c"

    it "returns false if the current selection doesn't allowPrevious", ->
      list.select 2
      spyOn(list.selection(), "allowPrevious").andReturn(false)
      expect(list.previous()).toBe false

    it "returns false if the current selection is the first", ->
      list.select 0
      expect(list.previous()).toBe false

    it "returns true if the selection has advanced", ->
      list.select 2
      expect(list.previous()).toBe true
