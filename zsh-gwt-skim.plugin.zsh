function gwt-skim() {
  local tmux_opts="${SKIM_TMUX_OPTS:-center,40%}"
  local layout="${tmux_opts%%,*}"
  local size_spec=""
  local -a sk_cmd sk_opts

  if [ "$layout" != "$tmux_opts" ]; then
    size_spec="${tmux_opts#*,}"
  fi

  if command -v sk >/dev/null 2>&1 && sk --help 2>/dev/null | grep -q -- '--tmux'; then
    sk_cmd=(sk)
    sk_opts=("--tmux=${tmux_opts}")
  elif command -v sk-tmux >/dev/null 2>&1; then
    sk_cmd=(sk-tmux)

    local first_size="" second_size=""
    local width height pos_x pos_y

    if [ -n "$size_spec" ]; then
      first_size="${size_spec%%,*}"
      [[ "$size_spec" == *,* ]] && second_size="${size_spec#*,}"
    fi

    # Replicate sk --tmux size/position logic using popup mode
    case "$layout" in
      top)
        if [ -n "$second_size" ]; then
          height="$first_size" width="$second_size"
        elif [ -n "$first_size" ]; then
          height="$first_size" width="100%"
        else
          height="50%" width="100%"
        fi
        pos_x="C" pos_y="0%"
        ;;
      bottom)
        if [ -n "$second_size" ]; then
          height="$first_size" width="$second_size"
        elif [ -n "$first_size" ]; then
          height="$first_size" width="100%"
        else
          height="50%" width="100%"
        fi
        pos_x="C" pos_y="100%"
        ;;
      left)
        if [ -n "$second_size" ]; then
          width="$first_size" height="$second_size"
        elif [ -n "$first_size" ]; then
          width="$first_size" height="100%"
        else
          width="50%" height="100%"
        fi
        pos_x="0%" pos_y="C"
        ;;
      right)
        if [ -n "$second_size" ]; then
          width="$first_size" height="$second_size"
        elif [ -n "$first_size" ]; then
          width="$first_size" height="100%"
        else
          width="50%" height="100%"
        fi
        pos_x="100%" pos_y="C"
        ;;
      center|*)
        if [ -n "$second_size" ]; then
          width="$first_size" height="$second_size"
        elif [ -n "$first_size" ]; then
          width="$first_size" height="$first_size"
        else
          width="50%" height="50%"
        fi
        pos_x="C" pos_y="C"
        ;;
    esac

    sk_opts=(-p "${width},${height}" -x "$pos_x" -y "$pos_y" --)
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
