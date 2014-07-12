base_require = require '../../spec_helper'
{DiffLine} = base_require 'models/diffs'


describe 'DiffLine', ->
  describe '.line', ->
    it 'returns the raw diff line', ->
      model = new DiffLine({line: 'this is it'})
      expect(model.line()).toEqual('this is it')

  describe '.type', ->
    it "returns 'addition' if it is an addition line", ->
      model = new DiffLine line: '+ this is it'
      expect(model.type()).toEqual('addition')

    it "returns 'subtraction' if it is a subtraction line", ->
      model = new DiffLine line: '- this is it'
      expect(model.type()).toEqual('subtraction')

    it "returns 'context' if it is a context line", ->
      model = new DiffLine line: ' this is it'
      expect(model.type()).toEqual('context')
