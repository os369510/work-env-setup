#!/bin/bash
PATH_UBUNTU="/home/jeremysu/Qemu/Ubuntu"
case $1 in
    ubuntu)
        qemu-system-x86_64\
            -m 8G\
            -vga std\
            -mem-path /dev/hugepages\
            -enable-kvm\
            -machine q35,accel=kvm\
            -device intel-iommu\
            -device vfio-pci,host=01:00.0\
            -cpu host\
            -drive format=raw,file=$PATH_UBUNTU/ubuntu-1804-disk
        ;;
    *)
        echo "Usage: $0 [ubuntu] (options)"
        exit 1
        ;;
esac
