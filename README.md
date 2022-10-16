# SVN Discord Hook

This is a `post-commit` hook for SVN servers to enable them to post to Discord
any time a commit happens.

## Installation

1. Clone this repo to your SVN server. Put it somewhere common since all repos
   can use the same scripts.
2. Copy `config.example.yaml` to `config.yaml` and update the `hooks` section
   with the correct repo names and hooks.
3. Create a symlink of the post commit script into each of your project `hooks`
   directories. See below for more instructions on symlinks.

## Symlinks

### Windows

Windows supports symlinks up using the `mklink` command. You'd run something
like this to create your symlink:

```batch
mklink "C:\svn\myproject\hooks\post-commit.bat" "C:\svn-discord-hook\post-commit.bat"
```

Note the first argument is the path to your SVN project's hook file and the
second is the path to the script in this repository. Adjust the paths as
necessary, of course.

### macOS/Linux

Here you'd use `ln -s` to create your symlink:

```batch
ln -s "/var/lib/svn-discord-hook/post-commit" "/var/lib/svn/myproject/hooks/post-commit"
```

Note the first argument is the path to the script in this repository and the
second is the path to the file in your SVN repo. Adjust the paths as necessary,
of course.
