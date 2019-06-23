#!/bin/bash
case $1 in
    jeremy-iphone)
        wpa_supplicant -B -i wlp3s0 -c /etc/wpa_supplicant/wifi_jeremy.conf
        dhcpcd wlp3s0
        ;;
    *)
        echo "Usage: sudo $0 [jeremy-iphone]"
        ;;
esac
