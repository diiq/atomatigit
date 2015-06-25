# atomatigit

Real git integration for the Atom text editor.

Atomatigit allows you to see diffs, stage chunks, make commits, push, fetch,
change branches, delete branches, discard changes... and if there's any function
you're missing, you can also execute raw git commands.

Atomatigit is designed to be used using ultra-fast keyboard shortcuts. Press
`cmd-alt-g` to show the atomatigit pane on the right. From there, you can
right-click on a file, branch, or commit to see your options, and to get a
friendly reminder of the keyboard shortcuts. Once you know the shortcuts, you
can navigate through 100% of atomatigit's functions without a mouse.

Atomatigit is inspired by the
[magit](http://magit.github.io/index.html) emacs package.

![screenshot: file list](http://i.imgur.com/rRk5sSy.png)
![screenshot: dark theme; branch list; context menu](http://i.imgur.com/axszNyW.png)

## Installing
Using `apm`:
``` shell
  apm install atomatigit
```

## Making changes and staging files

Press `cmd-alt-g` to show the atomatigit pane on the right.

As soon as you save a file, it will show up in the list of unstaged changes.
Navigate to it using arrow keys, i/k, or by clicking on it. Hit tab to see the
diff, and use `shift-s` to stage it.

## Committing

Once you've staged some files, initiate a commit by hitting `c`. A new buffer
will open for you to enter a commit message. When you're done describing your
changes, `cmd-alt-c` will complete the commit.

## Other Key bindings

There are many, but don't worry: if you ever forget these, Atomatigit has
right-click menus to help remind you. Here's the complete list:

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

Atomatigit is usable, but still in active development. Feel free to make feature requests.

## Missing features (coming soon)

You cannot merge, ammend, or rebase through the UI (though you can perform the commands using `atomatigit:git-command`).

Moved and deleted files have bad interactions (in terms of toggle-diff, etc).

The method for staging individual patches isn't the best interface.

## Contributing

Contributions are welcome!

`apm develop atomatigit`

Will clone the repo for you.

The code should be quite clear. If you add new files, don't forget to add them
to the correct `index.coffee` so they can be required from other directories.

Pull requests that break specs won't be merged, so be sure to run `apm test`
before you PR.

Pull requests that spec all their new public methods will get more attention
than those that don't :)

## Contributors

- [jonathanwiesel](https://github.com/jonathanwiesel)
- [frk1705](https://github.com/frk1705)
