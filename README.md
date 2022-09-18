# README
This repository maintains the configurations of Unix like system for myself.  

## Prerequisites
```
curl
```

## Install
```
git clone https://github.com/os369510/work-env-setup.git  
```

## Usage
### Docker
1. Setup a ubuntu environment  

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

- For jammy (22.04):  
```
docker pull os369510/ubuntu-jammy
bash env_setup.sh docker os369510/ubuntu-jammy ${dir-to-bind-in-docker}
```

2. Step 1 will call setup dotfiles as well.  
Please refer Dotfiles section below  

### Dotfiles
1. Apply dotfiles manually in current environment (`env_setup.sh docker` will
   chain to `env_setup.sh dotfiles`)  
```
cd work-env-setup
bash env_setup.sh dotfiles
```

2. Issue `vim` to install one time for installing plugins.  
3. `source ~/.bashrc` or logout/in to make the changes active.  

## Reference
[vim-go](https://github.com/fatih/vim-go)  
