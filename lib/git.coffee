Git = require 'promised-git'
git = null

getPath = ->
  if atom.project?.getRepo()
    atom.project.getRepo().getWorkingDirectory()
  else if atom.project
    atom.project.getPath()
  else
    __dirname

init = (path, repoView) ->



module.exports = new Git(getPath())
