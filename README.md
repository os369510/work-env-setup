# README
This repository maintains the configurations of Unix like system for myself.  

## Install
```
git clone https://github.com/os369510/work-env-setup.git  
```

## Usage
### Docker
1. Setup a ubuntu environment  

- For focal/jammy/noble (20.04, 22.04 or 24.04):  
```
# To use Ubuntu LTS series {focal,jammy,noble}
bash env_setup.sh docker os369510/ubuntu-noble ${dir-to-bind-in-docker}
# To use Redhat releases {ubi9}
bash env_setup.sh docker os369510/redhat-ubi9 ${dir-to-bind-in-docker}
# To use SUSE releases {bci}
bash env_setup.sh docker os369510/suse-bci ${dir-to-bind-in-docker}
```

2. Step 1 will call setup dotfiles as well.  
Please refer Dotfiles section below  

### Dotfiles
Apply dotfiles manually in current environment (`env_setup.sh docker` will
chain to `env_setup.sh dotfiles`)  
```
cd work-env-setup
bash env_setup.sh dotfiles
```

## Reference
[vim-go](https://github.com/fatih/vim-go)  
