## README
This repository maintains the configurations of Unix like system for myself.  

## Install
```
git clone https://github.com/os369510/work-env-setup.git  
```

## Usage
### Launch a `ubuntu`, `suse` or `redhat` docker environment  
```
# To use Ubuntu LTS series {focal,jammy,noble}
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

## Reference
[vim-go](https://github.com/fatih/vim-go)  
