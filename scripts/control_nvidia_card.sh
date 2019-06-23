#!/bin/bash
case $1 in
"on")
    sudo tee /proc/acpi/bbswitch <<<ON > /dev/null
    ;;
"off")
    sudo tee /proc/acpi/bbswitch <<<OFF > /dev/null
    ;;
*)
    echo "Usage: $0 [on|off]"
    exit 1
    ;;
esac
dmesg | tail -n 1
exit 0
