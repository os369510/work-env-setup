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

    # company dotfiles
    for dotfile in $DOTFILES; do
        $CP_CMD "$REPO/$DOTDIR/company/$dotfile" "$HOME/.$dotfile-company"
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
        VOL="$3"
        if [[ $OSTYPE == 'darwin'* ]]; then
            UID_VOL=$(id -u $(ls -ld ${VOL}| awk '{print $3}'))
        else
            UID_VOL=$(stat -c "%u" ${VOL})
        fi
        ORDER=0
        DOCKER_VOL=()
        DOCKER_VOLS_FROM_HOST=()
        DOCKER_USER_NAME="$(whoami)"
        ORG=""

        # ORG Detection
        if [[ "${DOCKER_IMG%%/*}" == *"nvidia"* ]]; then
            ORG="nvidia"
        fi

        # Container OS detection
        if [[ $DOCKER_IMG == *"ubuntu"* ]]; then
            DOCKER_USER_NAME="ubuntu"
        elif [[ $DOCKER_IMG == *"redhat"* ]]; then
            DOCKER_USER_NAME="redhat"
        elif [[ $DOCKER_IMG == *"suse"* ]]; then
            DOCKER_USER_NAME="suse"
        fi

        if [ "$VOL" == "" ] || [ ! -d "$VOL" ]; then
            echo "Not found '$VOL' or '$VOL' is not a directory."
            exit 255
        else
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${VOL}:/work-dir")
            DOCKER_VOLS_FROM_HOST+=("/work-dir")
        fi

        # Pass this repository to container
        DOCKER_VOL+=("-v")
        DOCKER_VOL+=("${DIR}:/work-env-setup:ro")

        # GPG
        if [ -d "${HOME}/.gnupg" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.gnupg:/.gnupg")
            DOCKER_VOLS_FROM_HOST+=("/.gnupg")
        fi

        # Git
        if [ -f "${HOME}/.gitconfig" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.gitconfig:/.gitconfig:ro")
            DOCKER_VOLS_FROM_HOST+=("/.gitconfig")
        fi

        if [ -f "${HOME}/.git-completion.sh" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.git-completion.sh:/.git-completion.sh:ro")
            DOCKER_VOLS_FROM_HOST+=("/.git-completion.sh")
        fi

        if [ -f "${HOME}/.git-prompt.sh" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.git-prompt.sh:/.git-prompt.sh:ro")
            DOCKER_VOLS_FROM_HOST+=("/.git-prompt.sh")
        fi

        # SSH
        if [ -d "${HOME}/.ssh" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.ssh:/.ssh:ro")
            DOCKER_VOLS_FROM_HOST+=("/.ssh")
        fi

        # Vim
        if [ -d "${HOME}/.vim" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.vim:/.vim:ro")
            DOCKER_VOLS_FROM_HOST+=("/.vim")
        fi

        if [ -f "${HOME}/.vimrc" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.vimrc:/.vimrc:ro")
            DOCKER_VOLS_FROM_HOST+=("/.vimrc")
        fi

        # Bash
        if [ -f "${HOME}/.bashrc" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.bashrc:/.bashrc:ro")
            DOCKER_VOLS_FROM_HOST+=("/.bashrc")
        fi

        if [ -f "${HOME}/.bash_profile" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.bash_profile:/.bash_profile:ro")
            DOCKER_VOLS_FROM_HOST+=("/.bash_profile")
        fi

        # Systemd
        if [ -d "/sys/fs/cgroup" ]; then
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("/sys/fs/cgroup:/sys/fs/cgroup:ro")
        fi

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
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("${HOME}/Workspace/cti:/workspace")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/dev:/dev")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/var/lock:/var/lock")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/proc:/proc")
                DOCKER_EXTRA_ARGS+=("--privileged")
            fi
        fi

        check_docker_is_installed

        check_docker_image_exist "$DOCKER_IMG"

        get_same_container_num ORDER "$DOCKER_BASE_NAME"
        ORDER=$((ORDER+1))
        DOCKER_NAME="${DOCKER_IMG//[.:\/]/-}-$ORDER"

        set -x
        export DOCKER_VOLS_FROM_HOST="${DOCKER_VOLS_FROM_HOST[@]}"
        docker run --rm -it "${DOCKER_EXTRA_ARGS[@]}" "${DOCKER_VOL[@]}" --privileged --name "$DOCKER_NAME"\
            "$DOCKER_IMG" bash -c "\
export DOCKER_VOLS_FROM_HOST='$DOCKER_VOLS_FROM_HOST'; \
bash /work-env-setup/setup_in_container.sh $UID_VOL $(whoami) $DOCKER_USER_NAME"
        set +x
        ;;
    dotfiles)
        setup_dotfiles "$DIR"
        ;;
    *)
        usage
esac
