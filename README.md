# zsh-gwt-skim

Jump into git worktree directory with skim fuzzy finding.

## Usage

Key binding | Behavior
--- | ---
Ctrl-w | Search git worktree with `sk --tmux`

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
