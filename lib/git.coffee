Git = require 'promised-git'

getPath = ->
  if atom.project?.getRepo()
    atom.project.getRepo().getWorkingDirectory()
  else if atom.project
    atom.project.getPath()
  else
    __dirname

module.exports = new Git(getPath())
