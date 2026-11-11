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

# Print the dir of a worktree, by number from wt l or exact/unique partial name
_wt_resolve() {
  local target="$1"
  local row name
  local -a rows matches
  rows=(${(f)"$(_wt_list)"})
  if [[ "$target" == <-> ]]; then
    if [ -z "$rows[$target]" ]; then
      echo "no worktree number $target" >&2
      return 1
    fi
    echo "${rows[$target]##*$'\t'}"
    return
  fi
  for row in $rows; do
    name="${${row%$'\t'*}##*$'\t'}"
    if [ "$name" = "$target" ]; then
      echo "${row##*$'\t'}"
      return
    fi
    [[ "$name" == *"$target"* ]] && matches+=("${row##*$'\t'}")
  done
  if (( $#matches == 1 )); then
    echo "$matches[1]"
  elif (( $#matches )); then
    echo "multiple worktrees match '$target':" >&2
    printf '  %s\n' "${matches[@]}" >&2
    return 1
  else
    echo "no worktree matches '$target'" >&2
    return 1
  fi
}

wt() {
  local cmd="${1:-l}"
  (( $# )) && shift
  local main dir branch lock rc
  local -a force all dirs
  case "$cmd" in
    l|list)
      _wt_list | awk -F'\t' '
        { rows[NR] = $0; if (length($3) > w) w = length($3) }
        END {
          for (i = 1; i <= NR; i++) {
            split(rows[i], f, "\t")
            printf("  %d. \033[33m%s: \033[37m%-*s\033[0m  \033[90m%s\033[0m\n", i, f[2], w, f[3], f[4])
          }
        }'
      ;;
    n|new)
      # Start an agent in a new tab and worktree on branch <name>: an existing local or origin branch,
      # else a new one off origin's default branch. Claude would name it worktree-<name>, so the
      # worktree is made here and claude -w reopens it.
      branch="${1:?usage: wt n <branch> [claude args]}"
      shift
      main=$(_wt_main)
      [ -n "$main" ] || return
      dir="$main/.claude/worktrees/${branch//\//+}"
      if [ ! -d "$dir" ]; then
        if git -C "$main" rev-parse -q --verify "refs/heads/$branch" >/dev/null ||
          git -C "$main" rev-parse -q --verify "refs/remotes/origin/$branch" >/dev/null; then
          git -C "$main" worktree add "$dir" "$branch" || return
        elif git -C "$main" rev-parse -q --verify origin/HEAD >/dev/null; then
          git -C "$main" worktree add --no-track -b "$branch" "$dir" origin/HEAD || return
        else
          git -C "$main" worktree add -b "$branch" "$dir" HEAD || return
        fi
      fi
      _wt_open_tab "$main" "claude -w ${(q)branch}${@:+ ${(j: :)${(q)@}}}" "${main:t}/$branch"
      ;;
    o|open)
      dir=$(_wt_resolve "${1:?usage: wt o <number|name>}") || return
      _wt_open_tab "$dir" "" "${$(_wt_main):t}/${dir:t}"
      ;;
    cd)
      dir=$(_wt_resolve "${1:?usage: wt cd <number|name>}") || return
      cd "$dir"
      ;;
    r|root)
      main=$(_wt_main)
      [ -n "$main" ] || return
      cd "$main"
      ;;
    d|delete)
      zparseopts -D -F -- f=force a=all || return
      main=$(_wt_main)
      [ -n "$main" ] || return
      if (( $#all )); then
        dirs=(${${${(f)"$(_wt_list)"}##*$'\t'}:#$main})
      elif (( $# )); then
        dir=$(_wt_resolve "$1") || return
        dirs=("$dir")
      else
        dir=$(git rev-parse --show-toplevel) || return
        dirs=("$dir")
      fi
      rc=0
      for dir in $dirs; do
        if [ "${dir:A}" = "${main:A}" ]; then
          echo "refusing to delete the main worktree" >&2
          rc=1
          continue
        fi
        branch=$(git -C "$dir" symbolic-ref -q --short HEAD)
        lock="$(git -C "$dir" rev-parse --absolute-git-dir)/locked"
        if [[ -f "$lock" && "$(<$lock)" =~ '^claude session .*\(pid ([0-9]+) start (.*)\)$' ]]; then
          if [ "${(j: :)${=$(ps -o lstart= -p $match[1])}}" = "${(j: :)${=match[2]}}" ]; then
            echo "claude session still running in ${dir:t} (pid $match[1]), exit it first" >&2
            rc=1
            continue
          fi
          git -C "$main" worktree unlock "$dir"
        fi
        if ! git -C "$main" worktree remove $force "$dir"; then
          rc=1
          continue
        fi
        [[ "${PWD:A}/" == "${dir:A}/"* ]] && cd "$main"
        if [ -z "$branch" ] || git -C "$main" branch -q -d "$branch" 2>/dev/null; then
          echo "deleted ${dir:t}"
        else
          echo "deleted ${dir:t}, kept unmerged branch $branch"
        fi
      done
      return $rc
      ;;
    *)
      cat >&2 <<'USAGE'
usage: wt [command]
  l, list                          list worktrees, most recent commit first (default)
  n, new <branch> [claude args]    new worktree and claude tab
  o, open <number|name>            focus or open a tab for a worktree
  cd <number|name>                 cd into a worktree
  r, root                          cd back to the main checkout
  d, delete [-f] [-a|number|name]  remove a worktree (default: current, -a: all) and its merged branch
USAGE
      return 1
      ;;
  esac
}

_wt() {
  local -a cmds
  cmds=(
    'l:list worktrees'
    'n:new worktree and claude tab'
    'o:focus or open a tab for a worktree'
    'cd:cd into a worktree'
    'r:cd back to the main checkout'
    'd:remove a worktree and its merged branch'
  )
  if (( CURRENT == 2 )); then
    _describe command cmds
    return
  fi
  case "$words[2]" in
    o|open|cd|d|delete)
      [[ "$words[CURRENT-1]" == (o|open|cd|d|delete|-f) ]] || return
      compadd -- ${${${(f)"$(_wt_list)"}%$'\t'*}##*$'\t'}
      ;;
    n|new)
      (( CURRENT == 3 )) || return
      compadd -- ${(u)${(f)"$(git for-each-ref --format='%(refname:lstrip=2)' refs/heads; git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin)"}:#HEAD}
      ;;
  esac
}
compdef _wt wt
