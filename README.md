## README
This repository maintains the configurations of Unix like system for myself.  

## Install
```
git clone https://github.com/os369510/work-env-setup.git  
```

## Usage
### Launch a `ubuntu`, `suse` or `redhat` docker environment  
```
# To use Ubuntu LTS series {bionic,focal,jammy,noble,resolute}
bash env_setup.sh docker os369510/ubuntu-noble ${dir-to-bind-in-docker}
# To use Redhat releases {ubi9}
bash env_setup.sh docker os369510/redhat-ubi9 ${dir-to-bind-in-docker}
# To use SUSE releases {bci}
bash env_setup.sh docker os369510/suse-bci ${dir-to-bind-in-docker}
```

### Apply dotfiles manually in current environment  
(`env_setup.sh docker` will chain to `env_setup.sh dotfiles` in docker env)  
```
cd work-env-setup
bash env_setup.sh dotfiles
```

### Kitty and Herdr on Sway

Sway opens Kitty with `Super+Enter`; terminal applications selected from the
launcher also use Kitty. Install `kitty` and `herdr` separately, then apply the
dotfiles to copy their configs. Their config directories are created when the
corresponding executable is installed.

Run `herdr` inside Kitty to attach to your session. The Herdr prefix is
`Ctrl+Q`: follow it with `h/j/k/l` to focus panes, `c` for a new tab, or `?`
for help. Kitty passes `Ctrl+Shift+Left/Right` to pane applications instead of
switching its own tabs; `Shift+Left/Right` and `Shift+Enter` use native keyboard
encoding. Keep `TERM` unchanged. If an SSH host does not recognize
`xterm-kitty`, use `kitten ssh HOST` to set up its terminfo.

After changing the Sway config, press `Super+Shift+C` to reload, then open a new
terminal. Reload Kitty's config with `Ctrl+Shift+F5` or open a new Kitty window.
Use `bash env_setup.sh diff-dotfiles` for a read-only comparison with live files.

### Preview Mermaid diagrams in Neovim

Open a Markdown file containing a fenced `mermaid` code block and press
`<Leader>mp` (Space, then `m`, then `p`). The preview opens in your browser and
updates while you edit; Neovim also prints the local preview URL. Press
`<Leader>mx` to stop the preview. The first Neovim launch installs the required
plugin; Node.js is not required because the plugin uses its prebuilt application.

## Reference
[vim-go](https://github.com/fatih/vim-go)  
