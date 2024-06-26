#!/bin/bash
function usage()
{
    echo "Usage: $0 (docker|dotfiles|diff-dotfiles)[docker-image][dir-for-home-in-docker]"
    echo "  $0 dotfiles"
    echo "  $0 diff-dotfiles"
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

    docker pull "$img"
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
    echo "# Step.$STEPS Setup dotfiles."

    set -x

    # dotfiles
    for dotfile in $DOTFILES; do
        $CP_CMD "$REPO/$DOTDIR/$dotfile" "$HOME/.$dotfile"
    done

    # company dotfiles
    while IFS= read -r -d '' dotfile; do
        $CP_CMD "$dotfile" "$HOME/.$(basename "$dotfile")-company"
    done < <(find "$REPO/$DOTDIR/company" -type f -print0)

    # oh-my-zsh theme
    $CP_CMD "$REPO/$DOTDIR/oh-my-zsh/themes/os369510.zsh-theme" "$HOME/.oh-my-zsh/themes/os369510.zsh-theme"

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
function diff_dotfiles()
{
    local REPO="$1"

    # dotfiles
    for dotfile in $DOTFILES; do
        echo "- Comparing $dotfile -"
        diff "$REPO/$DOTDIR/$dotfile" "$HOME/.$dotfile"
    done

    # company dotfiles
    while IFS= read -r -d '' dotfile; do
        echo "- Comparing $dotfile -"
        diff "$dotfile" "$HOME/.$(basename "$dotfile")-company"
    done < <(find "$REPO/$DOTDIR/company" -type f)

    echo "- Comparing oh-my-zsh/themes/os369510.zsh-theme - "
    $CP_CMD "$REPO/$DOTDIR/oh-my-zsh/themes/os369510.zsh-theme" "$HOME/.oh-my-zsh/themes/os369510.zsh-theme"

    echo "- Comparing .vimrc (.vim/* are skipped) -"
    $CP_CMD "$REPO"/"$DOTDIR"/vim/vimrc "$HOME"/.vimrc

    while IFS= read -r -d '' script; do
        echo "- Comparing $script-"
        diff "$script" "$SCRIPTDIR/$(basename "$script")"
    done < <(find "$REPO/$SCRIPTS" -type f -name "*.sh")
}

STEPS=1

DOTDIR="dotfiles"
SCRIPTS="scripts"
SCRIPTDIR="$HOME/.local/bin/my_scripts"
DOTFILES="git-completion.sh git-prompt.sh gitconfig bashrc \
bash_profile Xresources gdbinit myprofile zshrc git-completion.zsh"

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
        USAGE=""

        # USAGE Detection
        if [[ "${DOCKER_IMG}" == *"cti"* ]]; then
            USAGE="cti"
            echo "Detected cti usage."
        elif [[ "${DOCKER_IMG}" == *"gitlab-runner"* ]]; then
            USAGE="gitlab-runner"
            echo "Detected gitlab-runner usage."
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

        # Dotfiles
        for dotfile in $DOTFILES; do
            if [ ! -f "${HOME}/.${dotfile}" ]; then
                continue
            fi
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${HOME}/.${dotfile}:/.${dotfile}:ro")
            DOCKER_VOLS_FROM_HOST+=("/.${dotfile}")
        done

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

        # Bash, TODO: zsh support in container
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

        # Private company configurations
        while IFS= read -r -d '' dotfile; do
            bdotfile="$(basename "$dotfile")"
            DOCKER_VOL+=("-v")
            DOCKER_VOL+=("${dotfile}:/${bdotfile}:ro")
            DOCKER_VOLS_FROM_HOST+=("/${bdotfile}")
        done < <(find "$HOME" -maxdepth 1 -name '.*-company' -type f -print0)

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

        # If container is cti
        if [ "$USAGE" == "cti" ]; then
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
        elif [ "$USAGE" == "gitlab-runner" ]; then
            CONFIG_PATH="$HOME/.config/gitlab/config.toml"
            if [ -f "$CONFIG_PATH" ]; then
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("${HOME}/.config/gitlab/config.toml:/etc/gitlab-runner/config.toml:ro")
                DOCKER_VOL+=("-v")
                DOCKER_VOL+=("/var/run/docker.sock:/var/run/docker.sock")
            fi
        fi

        check_docker_is_installed

        check_docker_image_exist "$DOCKER_IMG"

        get_same_container_num ORDER "$DOCKER_BASE_NAME"
        ORDER=$((ORDER+1))
        DOCKER_NAME="${DOCKER_IMG//[.:\/]/-}-$ORDER"

        set -x
        export DOCKER_VOLS_FROM_HOST="${DOCKER_VOLS_FROM_HOST[@]}"
        if [ "$USAGE" == "gitlab-runner" ]; then
            docker run --rm -d "${DOCKER_EXTRA_ARGS[@]}" "${DOCKER_VOL[@]}" \
                --name "$DOCKER_NAME" "$DOCKER_IMG"
        elif [ "$USAGE" == "cti" ]; then
            docker run --rm -it "${DOCKER_EXTRA_ARGS[@]}" "${DOCKER_VOL[@]}" \
                --name "$DOCKER_NAME" "$DOCKER_IMG"
        else
            docker run --rm -it "${DOCKER_EXTRA_ARGS[@]}" "${DOCKER_VOL[@]}" \
                --name "$DOCKER_NAME" "$DOCKER_IMG" bash -c "\
export DOCKER_VOLS_FROM_HOST='$DOCKER_VOLS_FROM_HOST'; \
bash /work-env-setup/setup_in_container.sh $UID_VOL $(whoami) $DOCKER_USER_NAME"
        fi
        set +x
        ;;
    dotfiles)
        setup_dotfiles "$DIR"
        ;;
    diff-dotfiles)
        diff_dotfiles "$DIR"
        ;;
    *)
        usage
esac
