#!/bin/bash

VOL="$HOME/Workspace/docker-work-area"
REPO="$HOME/Workspace/WorkEnvSetup"
cp -r $REPO/dotfiles/.vim $VOL
docker run -it --rm -w /root -v $VOL:/root os369510/work-on-arch
