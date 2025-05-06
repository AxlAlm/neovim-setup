### My Neovim setup

## Requirements

Using `homebrew` as package manager

- neovim
- ghostty
- ohmyzsh
- python
- npm
- rust
- golang

## setup

There is an `install` command to install all needed packages via homebrew, but it serve more as a list of dependencies.

To symlink configuration files run the command `setup`.

See the `Makefile` for more info.

## some useful git alisas

```bash
[alias]
    lb = !git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf(\"  %d. \\033[33m%s: \\033[37m %s\\033[0m\\n\", NR, substr($2, 1, length($2)-1), $1)}'
    sw = "!f() { \
        git switch $(git lb | awk \"NR==$1 {print}\" | sed 's/\\x1b\\[[0-9;]*m//g' | awk '{print $NF}'); \
    }; f"

```
