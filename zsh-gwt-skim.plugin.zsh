function gwt-skim() {
  local tmux_opts="${SKIM_TMUX_OPTS:-center,40%}"
  local layout="${tmux_opts%%,*}"
  local size_spec=""
  local first_size=""
  local -a sk_cmd sk_opts sk_tmux_opts

  if [ "$layout" != "$tmux_opts" ]; then
    size_spec="${tmux_opts#*,}"
    first_size="${size_spec%%,*}"
  fi

  if command -v sk >/dev/null 2>&1 && sk --help 2>/dev/null | grep -q -- '--tmux'; then
    sk_cmd=(sk)
    sk_opts=("--tmux=${tmux_opts}")
  elif command -v sk-tmux >/dev/null 2>&1; then
    sk_cmd=(sk-tmux)
    case "$layout" in
      top)
        sk_tmux_opts=(-u)
        [ -n "$first_size" ] && sk_tmux_opts+=("$first_size")
        ;;
      bottom)
        sk_tmux_opts=(-d)
        [ -n "$first_size" ] && sk_tmux_opts+=("$first_size")
        ;;
      left)
        sk_tmux_opts=(-l)
        [ -n "$first_size" ] && sk_tmux_opts+=("$first_size")
        ;;
      right)
        sk_tmux_opts=(-r)
        [ -n "$first_size" ] && sk_tmux_opts+=("$first_size")
        ;;
      center|"")
        sk_tmux_opts=(-p)
        [ -n "$size_spec" ] && sk_tmux_opts+=("$size_spec")
        ;;
      *)
        sk_tmux_opts=(-p "$tmux_opts")
        ;;
    esac

    sk_opts=("${sk_tmux_opts[@]}" --)
  else
    zle -M "skim command not found (expected sk --tmux or sk-tmux)"
    zle reset-prompt
    return 1
  fi

  local target=$(git worktree list --porcelain | awk '/^worktree/ {print $2}' | "${sk_cmd[@]}" "${sk_opts[@]}" --query="$LBUFFER")

  if [ -n "$target" ]; then
    BUFFER="cd ${target}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N gwt-skim
bindkey "^w" gwt-skim
