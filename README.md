# atomatigit

Real git integration for the Atom text editor.

Atom's ability to show which files and which lines have been added, changed, and
removed is great.

I'd like to be able to see diffs, stage chunks, make commits, push, pull, change
branches, rebase... and every other thing that git allows.

It's hard to imagine how useful that ability is until you have it. The [magit]()
emacs package is my inspiration. In magit, staging, committing, and pushing take
only a few keystrokes.

![screenshot](https://www.dropbox.com/s/gt8wr0c1quluf16/Screenshot%202014-03-09%2023.04.57.png)

## Current status

I'm still puttering around at this stage. You can view the current status of the
repo -- which branch you're on, the last commit, and which files are staged,
unstaged, and untracked. You can stage files and make commits, but commit
messages are limited to one line. It's not ready for prime time, but it is
useful enough to dogfood during its development.

## Key bindings

- `ctrl-shift-z` to open/focus atomatigit
- `escape` to close
- `up` (or `i`) and `down` (or `k`) to navigate between files
- `enter` to open a selected file
- `tab` to see an unstaged diff
- `s` to stage a file
- `u` to unstage a file
- `c` to commit
- `escape` to abort a commit
- `r` to refresh the view (mostly happens automatically)
