_wt_main() {
  git worktree list --porcelain | sed -n '1s/^worktree //p'
}

_wt_list() {
  local dir
  for dir in ${(f)"$(git worktree list --porcelain | sed -n 's/^worktree //p')"}; do
    [ -d "$dir" ] || continue
    printf '%s\t%s\t%s\n' "$(git -C "$dir" log -1 --format='%ct%x09%cr')" "${dir:t}" "$dir"
  done | sort -rn
}

# Args: dir, command to run, tab label. Without a command, an open tab for dir is focused instead.
_wt_open_tab() {
  if [ "$TERM_PROGRAM" = ghostty ] && osascript - "$1" "$2" "$3" >/dev/null <<'APPLESCRIPT'
on run argv
  set targetDir to item 1 of argv
  set startCommand to item 2 of argv
  set tabLabel to item 3 of argv
  tell application "Ghostty"
    if startCommand is "" then
      repeat with w in windows
        repeat with t in tabs of w
          set tabOverride to name override of t
          repeat with s in terminals of t
            if tabOverride is tabLabel or (tabOverride is "" and working directory of s is targetDir) then
              activate window w
              select tab t
              focus s
              return
            end if
          end repeat
        end repeat
      end repeat
    end if
    set cfg to new surface configuration
    set initial working directory of cfg to targetDir
    if startCommand is not "" then set initial input of cfg to startCommand & linefeed
    set newTab to new tab in front window with configuration cfg
    if startCommand is not "" then set name override of newTab to tabLabel
  end tell
end run
APPLESCRIPT
  then
    return
  fi
  cd "$1" || return
  if [ -n "$2" ]; then
    eval "$2"
  fi
}

_wt_goto() {
  _wt_open_tab "$1" "" "${$(_wt_main):t}/${1:t}"
}

# Start an agent in a new tab and worktree, always branching off the main checkout
cw() {
  local name="${1:?usage: cw <name> [claude args]}"
  shift
  local main
  main=$(_wt_main)
  [ -n "$main" ] || return
  _wt_open_tab "$main" "claude -w ${(q)name}${@:+ ${(j: :)${(q)@}}}" "${main:t}/$name"
}

# List worktrees, most recent commit first
wl() {
  _wt_list | awk -F'\t' '{printf("  %d. \033[33m%s: \033[37m %s\033[0m\n", NR, $2, $3)}'
}

# Focus or open a tab for a worktree, by number from wl or exact/unique partial name
ws() {
  local target="${1:?usage: ws <number|name>}"
  local row name
  local -a rows matches
  rows=(${(f)"$(_wt_list)"})
  if [[ "$target" == <-> ]]; then
    if [ -z "$rows[$target]" ]; then
      echo "no worktree number $target" >&2
      return 1
    fi
    _wt_goto "${rows[$target]##*$'\t'}"
    return
  fi
  for row in $rows; do
    name="${${row%$'\t'*}##*$'\t'}"
    if [ "$name" = "$target" ]; then
      _wt_goto "${row##*$'\t'}"
      return
    fi
    [[ "$name" == *"$target"* ]] && matches+=("${row##*$'\t'}")
  done
  if (( $#matches == 1 )); then
    _wt_goto "$matches[1]"
  elif (( $#matches )); then
    echo "multiple worktrees match '$target':" >&2
    printf '  %s\n' "${matches[@]}" >&2
    return 1
  else
    echo "no worktree matches '$target'" >&2
    return 1
  fi
}
