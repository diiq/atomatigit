Git     = require 'promised-git'

getPath = ->
  if atom.project.getRepo()
    atom.project.getRepo().getWorkingDirectory()
  else
    atom.project.getPath()

module.exports = new Git(getPath())
