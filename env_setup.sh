#!/bin/bash

function check_docker_installed()
{
    local ret=$1
    local ver=""
    local installed='255'

    echo "# Step.$STEPS Check docker whether already installed?"

    ver=`docker --version`
    installed=`echo $?`
    if [ "$installed" -eq '0' ]; then
        echo "-- $ver"
    else
        echo "-- not found docker."
    fi
    STEPS=$(($STEPS+1))

    eval $ret="'$installed'"
}
function check_arch_image_exist()
{
    local ret=$1
    local id=""
    local existed='255'

    echo "# Step.$STEPS Check docker image of arch whether existed?"
    echo "-- Required docker image: $DOCKER_IMG"

    id=`docker images -q $DOCKER_IMG`
    existed=`echo $?`
    if [ "$existed" -eq '0' ]; then
        echo "--- Image ID - $id"
    else
        echo "-- not found $DOCKER_IMG"
    fi
    STEPS=$(($STEPS+1))

    eval $ret="'$existed'"
}
function get_same_container_num()
{
    local ret=$1
    local count='0'

    echo "# Step.$STEPS Get the number of same container."

    count=`docker ps -a| grep $DOCKER_BASE_NAME| wc -l`
    STEPS=$(($STEPS+1))

    eval $ret="'$count'"
}
function setup_dotfiles()
{
    echo "# Step.$STEPS Setup dotfiles."

    for dotfile in $DOTFILES; do
        cp $REPO/$DOTDIR/$dotfile $VOL/.$dotfile
    done

    cp -r $REPO/$DOTDIR/vim $VOL/.vim
    cp -r $REPO/$DOTDIR/vim/vimrc $VOL/.vimrc

    STEPS=$(($STEPS+1))
}

STEPS=1

DOTDIR="dotfiles"
DOTFILES="git-completion.sh git-prompt.sh bashrc bash_profile"
WORK_DIR="Workspace"

VOL_NAME="docker-work-area"
REPO="$HOME/$WORK_DIR/WorkEnvSetup"

DOCKER_BASE_NAME="work-on-arch"
DOCKER_IMG="os369510/work-on-arch"

case $1 in
    docker)
        VOL="$HOME/$WORK_DIR/$VOL_NAME"

        check_docker_installed res
        [ "$res" -ne 0 ] && exit -1

        check_arch_image_exist res
        [ "$res" -ne 0 ] && exit -1

        get_same_container_num order
        order=$(($order+1))
        DOCKER_NAME="$DOCKER_BASE_NAME-$order"

        setup_dotfiles

        docker run -it --rm -w /root -v $VOL:/root --name $DOCKER_NAME $DOCKER_IMG
        ;;
    dotfiles)
        VOL="$HOME"
        setup_dotfiles
        ;;
    *)
        echo "Usage: $0 (docker|dotfiles)"
        exit 1
esac
