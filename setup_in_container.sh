#!/bin/bash

IFS=' ' read -r -a vols_from_host <<< "$DOCKER_VOLS_FROM_HOST"

# $1 is the UID of volume
# $2 name of host user
# $3 docker default user name

if [[ $3 == *"ubuntu"* ]]; then
    group="sudo"
elif [[ $3 == *"redhat"* ]]; then
    group="wheel"
elif [[ $3 == *"suse"* ]]; then
    group="wheel"
fi

# If the uid of volume is 1000, means container user could access it, otherwise,
# it will create a hostuser for you to access your volume and then su to it.
if ! grep -q ":$1:" /etc/passwd; then
    echo "== Your volume needs uid $1, will create your host user now. ==" && \
    sudo useradd -g $group -u $1 -d /home/$2 -m -s /bin/bash $2 || exit 255
    echo "$2:$2" | sudo chpasswd
    for vol in "${vols_from_host[@]}"; do
        if [ -e "$vol" ]; then
            sudo ln -sf "$vol" "/home/$2/$(basename $vol)"
            echo "Created symbolic link from $vol /home/$2/$(basename "$vol")"
        fi
    done
    sudo su -l $2
# If the uid of volume onwer is 1000, continue to use it
else
    for vol in "${vols_from_host[@]}"; do
        if [ -e "$vol" ]; then
            sudo ln -sf "$vol" "$HOME/$(basename "$vol")"
            echo "Created symbolic link from $vol $HOME/$(basename "$vol")"
        fi
    done
    bash
fi
