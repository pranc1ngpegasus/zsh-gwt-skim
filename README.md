# zsh-gwt-skim

Jump into git worktree directory with skim fuzzy finding.

## Usage

Key binding | Behavior
--- | ---
Ctrl-w | Search git worktree with `sk --tmux=${SKIM_TMUX_OPTS:-center,40%}` (falls back to `sk-tmux`)

## Customization

Use environment variables to customize skim behavior:

```zsh
export SKIM_TMUX_OPTS='bottom,80%'
export SKIM_DEFAULT_OPTIONS='--layout reverse-list --inline-info'
```

- `SKIM_TMUX_OPTS` controls tmux layout/size (for example `bottom,80%`) and is mapped for both `sk --tmux` and `sk-tmux` fallback.
- `SKIM_DEFAULT_OPTIONS` is passed through to skim as-is; this plugin does not override it.
- If `sk --tmux` is unavailable, the plugin falls back to `sk-tmux`.

## Installation
### Nix flakes

```nix:flake.nix
{
    inputs = {
        zsh-gwt-skim = {
            url = "github:pranc1ngpegasus/zsh-gwt-skim";
            flake = false;
        };
    };
}
```

```nix:zsh.nix
{inputs, ...}: {
    programs.zsh = {
        enable = true;
        plugins = [
            {
                name = "zsh-gwt-skim";
                src = inputs.zsh-gwt-skim;
            }
        ];
    };
}
```
