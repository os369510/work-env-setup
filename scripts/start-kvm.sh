#!/bin/bash
function usage() {
    echo "$0 [emulation] [mode] {iso} {disk}"
    printf "\temulation:"
    printf "\t\tx86: x86_64 arch"
    printf "\t\taarch64: aarch64 arch"
    printf "\tmode:"
    printf "\t\tinstall: intallation mode"
    printf "\t\tnormal: normal mode"
    printf "\t\tpxelive: pxe boot a live session"
    exit 255
}
OS=$(uname -s)
case "$OS" in
    Darwin)
        if [ "$#" -lt 2 ]; then
            usage
        fi
        if [ "$2" == "install" ]; then
            install=yes
        fi
        LIBVIRT_PATH="$HOME/.local/share/libvirt"
        BOOTLOADER="/opt/homebrew/Cellar/qemu/8.2.0/share/qemu/edk2-x86_64-code.fd"
        IMG_PATH="$LIBVIRT_PATH/images"
        case "$1" in
            x86)
                ISO="noble-live-server-amd64.iso"
                DISK="ubuntu-dev-amd64.qcow2"
                ARG="-machine type=q35,accel=tcg \
                     -smp 8 -m 8196 \
                     -drive if=pflash,file=${BOOTLOADER},format=raw \
                     -drive id=hd0,media=disk,if=none,format=qcow2,file="$IMG_PATH/$DISK" \
                     -device virtio-net-pci,netdev=net0 \
                     -netdev user,id=net0,hostfwd=tcp::2222-:22 \
                     -device virtio-blk-pci,drive=hd0"
                if [ -n "$install" ]; then
                    ARG="$ARG -boot menu=on \
                         -drive id=cdrom1,media=cdrom,if=none,file="$IMG_PATH/$ISO" \
                         -device virtio-scsi-pci -device scsi-cd,drive=cdrom1"
                fi
                CMD="qemu-system-x86_64 $ARG"
                ;;
            aarch64)
                if [ -f "$3" ]; then
                    ISO="$3"
                else
                    ISO="noble-live-server-arm64.iso"
                fi
                if [ -f "$4" ]; then
                    DISK="$4"
                else
                    DISK="ubuntu-dev-aarch64.qcow2"
                fi
                ARG="-accel hvf -cpu host -smp 8 -M virt -m 4096 \
                     -bios $IMG_PATH/QEMU_EFI.fd \
                     -serial stdio \
                     -display default,show-cursor=on \
                     -device qemu-xhci -device usb-kbd -device usb-tablet \
                     -device intel-hda \
                     -drive id=hd0,media=disk,if=none,format=qcow2,file="$IMG_PATH/$DISK" \
                     -virtfs local,path="${HOME}"/Workspace/linux,mount_tag=host-ws,security_model=passthrough,id=host-ws \
                     -device virtio-net-pci,netdev=vmnet \
                     -netdev user,id=vmnet,hostfwd=tcp::2222-:22 \
                     -nic vmnet-bridged,ifname=en8 \
                     -device virtio-blk-device,drive=hd0"
                if [ -n "$install" ]; then
                    ARG="$ARG \
                         -drive id=cdrom1,media=cdrom,if=none,file=${IMG_PATH}/${ISO} \
                         -device virtio-scsi-device -device scsi-cd,drive=cdrom1 \
                         -device virtio-net-pci,netdev=vmnet \
                         -netdev user,id=vmnet,hostfwd=tcp::2222-:22"
                elif [ "$2" == "normal" ]; then
                     ARG="$ARG \
                          -drive id=hd0,media=disk,if=none,format=qcow2,file=${IMG_PATH}/${DISK} \
                          -device virtio-blk-device,drive=hd0 \
                          -device virtio-net-pci,netdev=vmnet \
                          -netdev user,id=vmnet,hostfwd=tcp::2222-:22"
                elif [ "$2" == "pxelive" ]; then
                     ARG="$ARG \
                          -device virtio-net-pci,netdev=vmnet-pxe,mac=12:23:45:56:67:78 \
                          -netdev user,id=vmnet-pxe,tftp=/var/tftpboot,bootfile=BOOTAA64.EFI \
                          -boot n"
                    CMD="sudo"
                fi
                CMD="$CMD qemu-system-aarch64 $ARG"
                ;;
            *)
                usage
                ;;
        esac
        set -x
        eval "$CMD"
        set +x
        ;;
    *)
        if [ "$#" -lt 2 ]; then
            usage
        fi
        if [ "$2" == "install" ]; then
            install=yes
        fi
        LIBVIRT_PATH="$HOME/.local/share/libvirt"
        BOOTLOADER="$LIBVIRT_PATH/edk2"
        IMG_PATH="$LIBVIRT_PATH/images"
        case "$1" in
            aarch64)
                if [ -f "$3" ]; then
                    ISO="$3"
                else
                    ISO="ubuntu-22.04.4-live-server-arm64.iso"
                fi
                if [ -f "$4" ]; then
                    DISK="$4"
                else
                    DISK="ubuntu-22.04-server-aarch64.qcow2"
                fi
                ARG="-accel tcg -cpu cortex-a710 -smp 8 -M virt -m 4096 \
                     -bios $BOOTLOADER/$1/QEMU_EFI.fd \
                     -serial stdio \
                     -display default,show-cursor=on \
                     -device qemu-xhci -device usb-kbd -device usb-tablet \
                     -device intel-hda"
                if [ "$2" == "install" ]; then
                    ARG="$ARG \
                     -drive id=cdrom1,media=cdrom,if=none,file=${IMG_PATH/$ISO} \
                     -device virtio-scsi-device -device scsi-cd,drive=cdrom1 \
                     -drive id=hd0,media=disk,if=none,format=qcow2,file=${IMG_PATH}/${DISK} \
                     -device virtio-blk-device,drive=hd0"
                elif [ "$2" == "normal" ]; then
                    ARG="$ARG \
                     -drive id=hd0,media=disk,if=none,format=qcow2,file=${IMG_PATH}/${DISK} \
                     -device virtio-blk-device,drive=hd0"
                elif [ "$2" == "pxelive" ]; then
                    ARG="$ARG \
                         -netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
                         -device virtio-net,netdev=net0,mac=33:44:55:66:77:88 \
                         -boot menu=on"
                    CMD="sudo -E"
                fi
                CMD="$CMD qemu-system-aarch64 $ARG"
                ;;
            *)
                usage
                ;;
        esac
        set -x
        eval "$CMD"
        set +x
#        PATH_UBUNTU="$HOME/Qemu/Ubuntu"
#        case $1 in
#            ubuntu)
#                qemu-system-x86_64\
#                    -m 8G\
#                    -vga std\
#                    -mem-path /dev/hugepages\
#                    -enable-kvm\
#                    -machine q35,accel=kvm\
#                    -device intel-iommu\
#                    -device vfio-pci,host=01:00.0\
#                    -cpu host\
#                    -drive format=raw,file=$PATH_UBUNTU/ubuntu-1804-disk
#                ;;
#            *)
#                echo "Usage: $0 [ubuntu] (options)"
#                exit 1
#                ;;
#        esac
        ;;
esac
