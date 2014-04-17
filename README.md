# atomatigit

Real git integration for the Atom text editor.

Atom's ability to show which files and which lines have been added, changed, and
removed is great, but I'd like to be able to see diffs, stage chunks, make
commits, push, pull, change branches, rebase... and every other thing that git
allows.

It's hard to imagine how useful that ability is until you have it. The
[magit](http://magit.github.io/index.html) emacs package is my inspiration. In
magit, staging, committing, and pushing take only a few keystrokes.

![screenshot](http://i.imgur.com/rRk5sSy.png)

## Key bindings

If you forget any of these, there are also context-sensitive right-click menus
to act as friendly reminders.

- `cmd-alt-g` to open/focus/close atomatigit
- `escape` to close
- `up` (or `i`) and `down` (or `k`) to navigate between items
- `c` to commit
- `cmd-alt-c` from a commit buffer to complete a commit
- `shift-P` to push to origin
- `b` to view branches
- `s` to view the staging area
- `l` to view the commit log
- `:` to execute a custom git command
- `r` to refresh
- `shift-p` to push the current branch to origin
- `f` to fetch

Staging View
- `enter` to open a selected file
- `tab` to see an unstaged diff
- `shift-s` to stage a file
- `u` to unstage a file
- `z` to stash
- `shift-Z` to unstash
- `backspace` to kill a diff, or delete an untracked file

Branch View
- `enter` to checkout the selected branch
- `c` to create a new branch
- `backspace` to delete a branch

Commit Log
- `enter` to soft reset to a selected commit
- `shift-enter` to hard reset


## Current status

Atomatigit is very close to its initial release. It's still very experimental,
but it is stable enough that I use it *almost* exclusively.

## Missing features (coming soon)

While you can view the individual chunks of a file diff, you cannot currently
stage them individually -- you can only stage the full file.

You cannot merge, ammend, or rebase through the UI.

Moved and deleted files have bad interactions (in terms of toggle-diff, etc).
