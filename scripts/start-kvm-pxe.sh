LIBVIRT_PATH="/Users/jszu/.local/share/libvirt/"
BOOTLOADER="/opt/homebrew/Cellar/qemu/8.2.0/share/qemu/edk2-x86_64-code.fd"
IMG_PATH="$LIBVIRT_PATH/images"

set -x
# the grub pxe
qemu-system-aarch64 -cpu host -accel hvf \
    -M virt -m 4096 -bios $IMG_PATH/QEMU_EFI.fd \
    -serial stdio \
    -display default,show-cursor=on \
    -device qemu-xhci -device usb-kbd -device usb-tablet \
    -nic vmnet-bridged,ifname=en0 \
    -device virtio-net-pci,bootindex=1,netdev=vmnet-pxe,mac=12:23:45:56:67:78 \
    -netdev user,id=vmnet-pxe,tftp=/private/tftpboot,bootfile=BOOTAA64.EFI \
    -boot n $@


#    -device virtio-net-pci,netdev=vmnet-pxe,mac=12:23:45:56:67:78 \
#    -netdev user,id=vmnet-pxe,tftp=/private/tftpboot,bootfile=BOOTAA64.EFI \
#    -serial stdio -smp 4 -nographic \
#
#    -nic vmnet-shared,model=virtio-net-pci,mac=12:23:45:56:67:78 \
#    -netdev user,id=vmnet-shared,tftp=/private/tftpboot,bootfile=BOOTAA64.EFI \

# the syslinux pxe
#qemu-system-aarch64 -cpu host -accel hvf \
#    -M virt -m 4096 -bios $IMG_PATH/QEMU_EFI.fd \
#    -serial stdio \
#    -display default,show-cursor=on \
#    -device qemu-xhci -device usb-kbd -device usb-tablet \
#    -device virtio-net-pci,bootindex=1,netdev=vmnet-pxe,mac=12:23:45:56:67:78 \
#    -netdev user,id=vmnet-pxe,tftp=/private/tftpboot/syslinux/efi64,bootfile=syslinux.efi \
#    -boot n $@
#
#    -nic vmnet-bridged,ifname=en8 \
