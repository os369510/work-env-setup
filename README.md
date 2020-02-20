# README
This repository maintains the configurations of Unix like system for myself.  

## Install
```
git clone https://github.com/os369510/work-env-setup.git  
```

## Usage
1. Apply dotfiles in current environment  
```
cd work-env-setup
bash env_setup.sh dotfiles
```

2. Setup a ubuntu environment  

- For bionic (18.04):  
```
docker pull os369510/ubuntu-bionic
bash env_setup.sh docker os369510/ubuntu-bionic ${dir-to-bind-in-docker}
```

- For focal (20.04):  
```
docker pull os369510/ubuntu-focal
bash env_setup.sh docker os369510/ubuntu-focal ${dir-to-bind-in-docker}
```

## Reference
[vim-go](https://github.com/fatih/vim-go)  
