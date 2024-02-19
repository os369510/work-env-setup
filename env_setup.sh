#!/bin/bash
function usage()
{
    echo "Usage: $0 (docker|dotfiles)[docker-image][dir-for-home-in-docker]"
    echo "  $0 dotfiles"
    echo "  $0 docker [docker-image] [dir-for-home-in-docker]"
    exit 1
}
function check_docker_is_installed()
{
    echo "# Step.$STEPS Check docker whether already installed?"

    if ! docker --version > /dev/null; then
        echo "-- Docker needs to be installed."
        exit 255
    else
        echo "-- Yes."
    fi
    STEPS=$((STEPS+1))
}
function check_docker_image_exist()
{
    local img=$1
    local id=""

    echo "# Step.$STEPS Pull and check docker image '$img' exists?"

    docker pull $img
    id=$(docker images -q "$img"| head -n 1)
    if [ "$id" != "" ]; then
        echo "-- Found '$img' ($id)."
    else
        echo "-- Not found $img."
        exit 255
    fi
    STEPS=$((STEPS+1))
}
function get_same_container_num()
{
    local ret=$1
    local count='0'

    echo "# Step.$STEPS Get the number of same container."

    count=$(docker ps -a| grep -c "$2")
    echo "-- Found total ${count}'s container(s) named $2."
    STEPS=$((STEPS+1))

    eval "$ret='$count'"
}
function setup_dotfiles()
{
    local REPO="$1"
    local DOTDIR="dotfiles"
    local SCRIPTS="scripts"
    local SCRIPTDIR="$HOME/.local/bin/my_scripts"
    local DOTFILES="git-completion.sh git-prompt.sh gitconfig bashrc \
bash_profile Xresources gdbinit myprofile zshrc"
    echo "# Step.$STEPS Setup dotfiles."

    set -x

    # dotfiles
    for dotfile in $DOTFILES; do
        $CP_CMD "$REPO/$DOTDIR/$dotfile" "$HOME/.$dotfile"
    done

    # vim
    mkdir -p "$HOME/.vim"
    $CP_CMD -R "$REPO"/"$DOTDIR"/vim/* "$HOME"/.vim/
    $CP_CMD "$REPO"/"$DOTDIR"/vim/vimrc "$HOME"/.vimrc

    # scripts
    mkdir -p "$SCRIPTDIR"
    if [ -d "$SCRIPTDIR" ]; then
        find "$REPO/$SCRIPTS" -name "*.sh"\
            -exec sh -c 'x="$1";y=$2; ln -s "$x" "$y/$(basename $x)"'\
            _ {} "$SCRIPTDIR" \; > /dev/null 2>&1
    fi

    set +x

    STEPS=$((STEPS+1))
}

STEPS=1

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CP_CMD="cp -u"

if [[ $OSTYPE == 'darwin'* ]]; then
    CP_CMD="cp"
fi

case $1 in
    docker)
        if [ "$2" == "" ] || [ "$3" == "" ]; then
            usage
            exit 255
        fi

        DOCKER_BASE_NAME=${2#*/}
        DOCKER_IMG=$2
        eval VOL="$3"
        ORDER=0
        DOCKER_VOL=()
        DOCKER_USER_NAME="$(whoami)"
        DOCKER_WORK_DIR="/"
        ORG=""

        # ORG Detection
        if [[ "${DOCKER_IMG%%/*}" == *"nvidia"* ]]; then
            ORG="nvidia"
        fi

        if [ "$VOL" == "" ] || [ ! -d "$VOL" ]; then
            echo "Not found '$VOL' or '$VOL' is not a directory."
            exit 255
        else
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${VOL}:/home/${DOCKER_USER_NAME}/work-dir")
            DOCKER_WORK_DIR="/home/${DOCKER_USER_NAME}/work-dir"
        fi

        # GPG
        if [ -d "${HOME}/.gnupg" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.gnupg:/home/${DOCKER_USER_NAME}/.gnupg")
        fi

        # Git
        if [ -f "${HOME}/.gitconfig" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.gitconfig:/home/${DOCKER_USER_NAME}/.gitconfig:ro")
        fi

        if [ -f "${HOME}/.git-completion.sh" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.git-completion.sh:/home/${DOCKER_USER_NAME}/.git-completion.sh:ro")
        fi

        if [ -f "${HOME}/.git-prompt.sh" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.git-prompt.sh:/home/${DOCKER_USER_NAME}/.git-prompt.sh:ro")
        fi

        # SSH
        if [ -d "${HOME}/.ssh" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.ssh:/home/${DOCKER_USER_NAME}/.ssh:ro")
        fi

        # Vim
        if [ -d "${HOME}/.vim" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.vim:/home/${DOCKER_USER_NAME}/.vim:ro")
        fi

        if [ -f "${HOME}/.vimrc" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.vimrc:/home/${DOCKER_USER_NAME}/.vimrc:ro")
        fi

        # Bash
        if [ -f "${HOME}/.bashrc" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.bashrc:/home/${DOCKER_USER_NAME}/.bashrc:ro")
        fi

        if [ -f "${HOME}/.bash_profile" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.bash_profile:/home/${DOCKER_USER_NAME}/.bash_profile:ro")
        fi

        # Systemd
        if [ -d "/sys/fs/cgroup" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("/sys/fs/cgroup:/sys/fs/cgroup:ro")
        fi

        # To access the host users volumes
        DOCKER_VOL+=("-v")
        DOCKER_VOL+=("/etc/group:/etc/group:ro")
        DOCKER_VOL+=("-v")
        DOCKER_VOL+=("/etc/passwd:/etc/passwd:ro")

        # Canonical oem-scripts
        if [ -f "${HOME}/Workspace/ubuntu-qemu/oem-credential/config.ini" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/Workspace/ubuntu-qemu/oem-credential/config.ini:/home/${DOCKER_USER_NAME}/.config/oem-scripts/config.ini:ro")
        fi

        # Canonical rclone
        if [ -f "${HOME}/Workspace/ubuntu-qemu/oem-credential/rclone.conf" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/Workspace/ubuntu-qemu/oem-credential/rclone.conf:/home/${DOCKER_USER_NAME}/.config/rclone/rclone.conf:ro")
        fi

        # If nvidia
        if [ "$ORG" == "nvidia" ]; then
            ENV_PATH="$HOME/.config/nv-cred/nv_gitlab_docker.env"
            if [ -f "$ENV_PATH" ]; then
                docker logout
                cat "$ENV_PATH"|\
                    awk -F'=' \
                    '/URL/ {URL=$2} /USER/ {USER=$2} /TOKEN/ {TOKEN=$2} END {print URL " -u " USER " -p " TOKEN}'| \
                    xargs docker login
                # Workaround warning
                rm "$HOME"/.docker/config.json

                # CTI
                DOCKER_EXTRA_ARGS+=("--privileged")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("${HOME}/Workspace/cti:/workspace")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/dev:/dev")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/var/lock:/var/lock")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/proc:/proc")
            fi
        fi

        check_docker_is_installed

        check_docker_image_exist "$DOCKER_IMG"

        get_same_container_num ORDER "$DOCKER_BASE_NAME"
        ORDER=$((ORDER+1))
        DOCKER_NAME="${DOCKER_IMG//[.:\/]/-}-$ORDER"

        set -x
        docker run --rm -it "${DOCKER_EXTRA_ARGS[@]}" "${DOCKER_VOL[@]}" --privileged --name "$DOCKER_NAME"\
            --user $(id -u):$(id -g) -w "$DOCKER_WORK_DIR" "$DOCKER_IMG"
        set +x
        ;;
    dotfiles)
        setup_dotfiles "$DIR"
        ;;
    *)
        usage
esac
