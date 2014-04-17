base_require = require '../spec_helper'
ListItem = base_require 'models/list-item'

class AListItem extends ListItem
  sublist: null

class Collection
  indexOf: () -> null
  select: () -> null

class SubList
  next: () -> null
  previous: () -> null

describe "ListItem", ->
  item = null
  beforeEach ->
    item = new AListItem

  describe ".selfSelect", ->
    it "calls .select if the item has no collection", ->
      item.set selected: false
      item.selfSelect()
      expect(item.get "selected").toBe true

    it "calls @collection.select if the item has a collection", ->
      item.collection = new Collection
      spyOn(item.collection, "indexOf").andReturn(0)
      spyOn(item.collection, "select")

      item.selfSelect()

      expect(item.collection.indexOf).toHaveBeenCalledWith(item)
      expect(item.collection.select).toHaveBeenCalledWith(0)

  describe ".select", ->
    it "sets .selected to be true", ->
      item.set selected: false
      item.select()
      expect(item.get "selected").toBe true

  describe ".deselect", ->
    it "sets .selected to be false", ->
      item.set selected: true
      item.deselect()
      expect(item.get "selected").toBe false

  describe ".selectedP", ->
    it "returns .selected", ->
      item.set selected: false
      expect(item.selectedP()).toBe false
      item.set selected: true
      expect(item.selectedP()).toBe true

  describe ".allowPrevious", ->
    it "returns true if the item useSublist returns false", ->
      expect(item.allowPrevious()).toBe true

    it "returns false if sublist.previous returns true", ->
      item.sublist = new SubList
      spyOn(item, "useSublist").andReturn(true)
      spyOn(item.sublist, "previous").andReturn(true)
      expect(item.allowPrevious()).toBe false
      expect(item.sublist.previous).toHaveBeenCalled

    it "returns true if sublist.previous returns false", ->
      item.sublist = new SubList
      spyOn(item, "useSublist").andReturn(true)
      spyOn(item.sublist, "previous").andReturn(false)
      expect(item.allowPrevious()).toBe true
      expect(item.sublist.previous).toHaveBeenCalled

  describe ".allowNext", ->
    it "returns true if the item.useSublist returns false
", ->
      expect(item.allowNext()).toBe true

    it "returns false if sublist.next returns true", ->
      item.sublist = new SubList
      spyOn(item, "useSublist").andReturn(true)
      spyOn(item.sublist, "next").andReturn(true)
      expect(item.allowNext()).toBe false
      expect(item.sublist.next).toHaveBeenCalled

    it "returns true if sublist.next returns false", ->
      item.sublist = new SubList
      spyOn(item, "useSublist").andReturn(true)
      spyOn(item.sublist, "next").andReturn(false)
      expect(item.allowNext()).toBe true
      expect(item.sublist.next).toHaveBeenCalled
