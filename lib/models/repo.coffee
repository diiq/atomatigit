{Model} = require 'backbone'
{spawn} = require 'child_process'
{File} = require 'pathwatcher'

{git} = require '../git'
{FileList} = require './files'
{CurrentBranch, BranchList} = require './branches'
{CommitList} = require './commits'


module.exports =
class Repo extends Model
  initialize: (opts) ->
    @file_list = new FileList []
    @branch_list = new BranchList []
    @commit_list = new CommitList []
    @current_branch = new CurrentBranch
    git.on "reload", @reload

  reload: =>
    git.setPath()
    @file_list.reload()
    @current_branch.reload()
    @branch_list.reload()
    @commit_list.reload(@current_branch)

  selection: ->
    @active_list.selection()

  leaf: ->
    @active_list.leaf()

  commitMessagePath: ->
    atom.project.getRepo().getWorkingDirectory() + "/.git/COMMIT_EDITMSG_ATOMATIGIT"

  fetch: ->
    git.incrementTaskCounter()
    git.remoteFetch "origin", =>
      git.decrementTaskCounter()

  checkoutBranch: ->
    @branch_list.checkout_branch

  stash: ->
    git.git "stash"

  stashPop: ->
    git.git "stash pop"

  initiateCommit: ->
    git.incrementTaskCounter()
    if atom.config.get("atomatigit.pre_commit_hook") != ""
      atom.workspaceView.trigger(atom.config.get("atomatigit.pre_commit_hook"))
    (new File @commitMessagePath()).write(@commit_message)
    atom.workspaceView.open @commitMessagePath()

  completeCommit: ->
    git.git "commit --file=\"#{@commitMessagePath()}\""
    git.decrementTaskCounter()

  initiateCreateBranch: ->
    @trigger "need_input",
      query: "Branch name"
      callback: (name) =>
        git.createBranch name, =>
          git.git "checkout #{name}"

  initiateGitCommand: ->
    @trigger "need_input",
      query: "Git command"
      callback: (command) => git.git command

  push: ->
    @current_branch.push()

  commit_message:
    ""
