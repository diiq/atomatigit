
v1.5.4 / 2015-08-04
==================

  * Allow whitespace in paths
  * Update atom API call
  * Use language-diff package

v1.5.2 / 2015-05-28
===================

  * Prepare 1.5.2 release

v1.5.1 / 2015-05-24
===================

  * Prepare 1.5.1 release

v1.5.0 / 2015-05-24
===================

  * Prepare 1.5.0 release
  * Hotkey to focus files-tab is now 'f'
  * Force commit to be displayed with --format=full

v1.4.0 / 2015-05-24
===================

  * Prepare 1.4.0 release
  * Fix deprecations in models/commit.coffee
  * Fix deprecated api
  * Don't use atom.workspaceView
  * Update to use atom-space-pen-views
  * Replace `atom.project.getRepo()` with `atom.project.getRepositories()[0]`
  * Fix CSON format
  * Rename `stylesheets/` to `styles/`

v1.3.0 / 2015-04-18
===================

  * Prepare 1.3.0 release
  * Some more warning removal
  * Fixed latest deprecation
  * Fixed deprecation
  * Removed debug code
  * Prevent further duplicated issues by fixing a deprecation
  * Remove use of the 'wc' command

v1.2.3 / 2015-01-15
===================

  * Prepare 1.2.3 release
  * Refresh the view after pushing
  * Having 2 systems handle reloads works better

v1.2.2 / 2015-01-15
===================

  * Prepare 1.2.2 release
  * Fix impact on atom startup time
  * Make sure atomatigit:close always gets registered. Fixes #57
  * Added commit comparisons
  * Upon closing, refocus the editor. Fixes #46
  * Refresh the view when focused for up-to-date info
  * Make sure we only load the repo info once

v1.2.1 / 2015-01-12
===================

  * Prepare 1.2.1 release
  * Fix bug on initalizing atomatigit

v1.2.0 / 2015-01-11
===================

  * Prepare 1.2.0 release
  * Error won't show if opening a non-git project
  * Triggering show shows it when the editor is ready
  * Make sure the show command always gets registered
  * Modules now load on package activation
  * Make the package load automatically
  * Added show_on_startup config item
  * Updated config items to have descriptions

v1.1.0 / 2015-01-08
===================

  * Prepare 1.1.0 release
  * Current branch name no longer toggles weight.
  * InputView now gives focus back to RepoView
  * After commiting, return focus to atomatigit
  * Made reselection happen after repaint
  * Made selected items prominent when focused.
  * Exposed focus functions.

v1.0.4 / 2015-01-07
===================

  * Prepare 1.0.4 release
  * Trigger atomatigit:refresh after git commands
  * RepoView refreshes after branch creation.
  * Update fs-plus to 2.3.2

v1.0.3 / 2014-12-12
===================

  * Prepare 1.0.3 release
  * Fix error when disabling atomatigit (#48)

v1.0.2 / 2014-12-07
===================

  * Prepare 1.0.2 release
  * Display a message upon successful push to remote
  * Fix branch name decoding error
  * Refresh atom git status upon committing

v1.0.1 / 2014-12-02
===================

  * Prepare 1.0.1 release
  * Make sure detach has the right context here too
  * Fix timed detach of output view

v1.0.0 / 2014-10-04
===================

  * Prepare 1.0.0 release
  * Upgrade fs-plus to 2.3.1
  * Upgrade promised-git to 0.1.1
  * Upgrade promised-git to 0.1.0
  * Fix atomatigit focus behaviour
  * Fix resizing
  * :lipstick: fat arrows
  * Fix focus/close errors
  * :lipstick: Optimizations
  * Fix file list navigation errors
  * Upgrade to backbone 1.1.2
  * Remove old specs
  * Optimize callbacks
  * :lipstick:
  * Fix 'needInput' functionality
  * Fix custom git command input
  * Simplify if-else logics
  * Remove file overwriting, fix #36
  * :memo: atomatigit.coffee documentations
  * Guard ::hasParent()
  * Remove deprecated api call
  * Add more comments
  * :lipstick: Sort case sensitive. Better guarding
  * Guard atomatigit against non-git projects
  * :memo: Update documentations
  * Better guarding
  * Fix diffs
  * Add a 'debug' setting to log error stacks
  * Display the git porcelain status for each file
  * :lipstick:
  * Fix file list bugs with deleted files
  * :lipstick:
  * Fix committing, commit on save
  * Simplify file-list code
  * Fix untracked files invisible
  * Fix CPU loop
  * :lipstick:
  * Update the commitList after (hard)reset
  * Fix dead variable reference
  * When a branch is checked out update the commitList
  * Fix branch-list
  * We need to require ErrorView before using it
  * Remove dead code
  * Fix showCommit feature
  * git commands are guarded and show error message
  * Update error-view
  * Fix commit-list
  * Fix file list
  * Fix file-list
  * Update models/list-item.coffee
  * Update models/list.coffee
  * Empty functions should use -> return
  * Update views/repo-view.coffee
  * Update views/files
  * Update views/error-view.coffee
  * Update views/diffs/index.coffee
  * Update views/commits
  * Update views/branches
  * Update models/repo.coffee
  * Update models/list.coffee
  * Update models/files
  * Update models/diffs
  * Update models/commits
  * Update models/branches
  * Update git.coffee
  * Update atomatigit.coffee
  * Update .gitignore to ignore vim tags file
  * Remove vim tags file
  * Update models/branches/remote-branch.coffee
  * Update models/branches/local-branch.coffee
  * Update models/branches/current-branch.coffee
  * Update models/branches/branch.coffee
  * Update repo.coffee
  * Remove gift, introduce promised-git
  * Replace underscore with lodash
  * Fix errors introduced by 15ae56d99d9da407fd48f5aa3eed14ef1def2842
  * Revert changes to README
  * Doubles quotes are evil :lipstick:
  * Fix spec
  * More guarding
  * Fix exception on non-git projects

v0.5.0 / 2014-07-31
===================

  * Prepare 0.5.0 release
  * Remove pathwatcher dependency
  * Fix junks folders created for patch file
  * Escape special characters, hotfix for atom bug
  * Add ability to open commit-diffs from log view

v0.4.0 / 2014-06-10
===================

  * Prepare 0.4.0 release
  * Fix specs
  * Remove dependency on Snippets package
  * Generate each commitline from File-object
  * :lipstick: Refactor commit message
  * Code optimization
  * Fix TypeError in diff.coffee
  * Replace unnecessary fat arrows
  * Replace underscore_plus with underscore
  * Type error in diff.coffee
  * Fix type error upon completed commit
  * Improve code format
  * Set --cleanup=strip for commiting from file
  * Flush old entries from commit message file
  * Extend pretty commit message
  * :lipstick: Add pretty commit msg alpha
  * Fix indent
  * :lipstick: Fix diff error on binary files
  * :lipstick: Fix error on unborn repositories.
  * :memo: Fix small typo in README
  * :lipstick: Remove unnecessary second git path definition.

v0.3.7 / 2014-05-20
===================

  * Prepare 0.3.7 release
  * Fix HTML escape problem.

v0.3.6 / 2014-05-12
===================

  * Prepare 0.3.6 release
  * README: Add frk1705 to contributors.
  * Remove unnecessary show keybinds.
  * Fix typo at keymaps/atomatigit.cson.
  * Add win32/linux keybindings.

v0.3.5 / 2014-05-11
===================

  * Prepare 0.3.5 release
  * Unicodify warning messages.

v0.3.4 / 2014-05-10
===================

  * Prepare 0.3.4 release
  * Unicodify author name.

v0.3.3 / 2014-05-10
===================

  * Prepare 0.3.3 release
  * Begins to fix the places gift returns a poorly-encoded string.

v0.3.2 / 2014-05-10
===================

  * Prepare 0.3.2 release
  * Fixes vim-like next/previous keybindings.
  * Fixes embarrassing typo in commit message.

v0.3.1 / 2014-04-27
===================

  * Prepare 0.3.1 release
  * Commit messages are BORKED. :(

v0.3.0 / 2014-04-26
===================

  * Prepare 0.3.0 release
  * Update readme.
  * Keeps the diff list open on refresh.
  * I can stage individual diff chunks! Hurrah!

v0.2.7 / 2014-04-25
===================

  * Prepare 0.2.7 release
  * Fix a spec, update the readme to show contributors.

v0.2.6 / 2014-04-25
===================

  * Prepare 0.2.6 release
  * Add toggle diff menu for unstaged view

v0.2.5 / 2014-04-23
===================

  * Prepare 0.2.5 release
  * Add 'j' to keymap per request.
  * Remove pushed/unpushed status for now.

v0.2.4 / 2014-04-22
===================

  * Prepare 0.2.4 release
  * Commit files in directories with space.

v0.2.3 / 2014-04-22
===================

  * Prepare 0.2.3 release
  * Brief commit comment to explain committing.

v0.2.2 / 2014-04-17
===================

  * Prepare 0.2.2 release
  * Fixed screenshot.

v0.2.1 / 2014-04-17
===================

  * Prepare 0.2.1 release
  * Fix readme to be more friendly.
  * CurrentBranch spec.
  * Branch list spec.

v0.2.0 / 2014-04-16
===================

  * Prepare 0.2.0 release
  * Fix readme keybindings for show and complete commit

v0.1.0 / 2014-04-16
===================

  * Prepare 0.1.0 release
  * Package repository url
  * Short package description
  * Stage removed files.
  * Readme improvements.
  * Slightly better commit message
  * Delete untracked files.
  * Current branch view.
  * Context menus!
  * Refocus after commit
  * Fixes the focus problem.
  * Spinner runs for all tasks.
  * Fixes kill, git command, etc.
  * Working active view, again.
  * Much improved commit message editing.
  * Commit list; CurrentBranch
  * Push.
  * Working commit list view.
  * Commit and specs
  * Remove error model. Yay
  * Relative require tweaks, round 2.
  * Finish tweaking relative requires, round 1
  * Directories of dooooom.
  * RemoteBranch specs
  * Specs for Branch and LocalBranch
  * Branch list is working
  * Branch, RemoteBranch, LocalBranch.
  * Sublists working properly.
  * Tweaking Git to behave properly for diffs
  * FileListView and specs.
  * Git tidy status; FileList and specs
  * FileView and specs.
  * StagedFile, UnstagedFile, and specs
  * UntrackedFile model and specs
  * File model and specs.
  * DiffView and specs.
  * DiffChunkView and specs
  * Rename diff-line-view-spec
  * Diff model and specs
  * List model and specs
  * DiffChunk and specs
  * ListItem model and specs.
  * DiffLineView and specs.
  * Remove nonsense default specs.
  * New diff line plus specs.
  * Committing with atom is suck.
  * Removes console.logs.
  * Commit key binding.
  * Adds pre-commit hooks.
  * Fixes spinner after commit.
  * Commit messages in editor
  * Spinner for server-talking tasks.It's on the error model and view, which isn't perfect, but it *was* hella easy.
  * Checking out a local-only branch throws an error.It would be great if I had a more solid planin place for handling remotes.
  * Styling. Lord I don't know enough about css.
  * Tabs for main views. Not sure I like it.
  * Authors in commit log.
  * Hard-reset.
  * Commit list: `enter` to reset.`shift-enter` to hard reset.
  * Style commit list. Show initial selection.Removes some log statements, too.
  * Proper errors on branch checkout. Did a little refactor to clean that up, too,moving #checkout onto Branch, instead of BranchList.
  * Ugly but accurate commit log.Totally unstyled, and limited to 10 atm, but there it is!
  * Improved multiline input, error output.
  * Error messages!
  * Escape "commit" mess/ages !to make'em work.
  * Move up and down in multiline commit messages
  * Shift-enter to finish message added to block input queries.
  * Multi-line Commit messages
  * Refactor #toggle_diff into file; remove logs.
  * List Item Model; working diff.
  * Readme reflects current keybindings.
  * File#open refactor complete.
  * Kill branches, more refactor.
  * Moves kill onto file.
  * Moving stage/unstage out of Repo
  * Fix typo in keybindings
  * List and checkout remote branches!
  * Better global keybindings.
  * Flexible styling! Themes!
  * Resizeable!
  * Input query message.
  * Better diffs.
  * Styles additions and subtractions.
  * Diff, DiffChunk, and DiffLine views.
  * DiffChunk collection and DiffLine model
  * Diff and DiffChunk models
  * Diffs for staged files!
  * Better k-for-kill.
  * Checkout when you create a branch.
  * Click to select branches.
  * Fix post-message focus
  * Focus fix; git command command
  * Focus problems fixed!
  * Readme updated for additional keybindings
  * Stash and stash pop!
  * push other branches
  * Maybe fetch, hard to tell.
  * Checkout branch callback
  * Remove log statements.
  * Refresh on checkout
  * Create branches
  * Change branches, but with bad error handling.
  * Actually show all branches.
  * Tacks/hax on branch view.
  * Keep focus after input complete.
  * Fix pushed styling.
  * Branch#fetch for abstraction wins.
  * ListModel abstraction.
  * Unpushed commit styling
  * Test commit
  * Maybe pushing? We're about to see...
  * Kill unstaged diffs with k
  * Bad comment in .less
  * Fix readme screenshot
  * Bring readme up-to-date.
  * Able to abort commits with escape.
  * Working unstage.
  * Almost unstage.
  * Generalized message request.
  * Pretty diffs and short commit messages.
  * Show file diffs on <tab>
  * You can click on files.
  * Fixes activating command; open first try now.
  * Better last-commit-message formatting.
  * Accomodates files that are both staged and unstaged. Enter opens files.
  * Sorting, staging.
  * Readme key bindings
  * Readme.
  * Escape to quit.
  * Focus; navigation.
  * Branch in brief, no logs.
  * One repaint callback only, please.
  * Backbone models. Can't work out theorist.
  * Initial commit.
