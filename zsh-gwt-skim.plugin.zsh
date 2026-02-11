function gwt-skim() {
  local target=$(git worktree list --porcelain | awk '/^worktree/ {print $2}' | sk --tmux --query="$LBUFFER")

  if [ -n "$target" ]; then
    BUFFER="cd ${target}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N gwt-skim
bindkey "^w" gwt-skim
