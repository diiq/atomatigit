{View} = require 'atom'
FileView = require './file-view'

module.exports =
class FileListView extends View
  @content: ->
    @div =>
      @div outlet: "file_list"

  refresh: (files) ->
    @file_list.empty()
    for file, status of files
      @add_file file, status

  add_file: (filename, status) ->
    @file_list.append(new FileView(filename, status))
