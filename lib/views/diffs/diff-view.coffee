_             = require 'lodash'
{View}        = require 'atom'
DiffChunkView = require './diff-chunk-view'

class DiffView extends View
  @content: (diff) ->
    @div class: 'diff'

  initialize: (@model) ->
    _.each @model?.chunks(), (chunk) => @append new DiffChunkView chunk

module.exports = DiffView
