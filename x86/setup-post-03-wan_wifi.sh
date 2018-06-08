#!/bin/bash

dev=( wlp8s0 )
essid=( "REVERE-2.4GHz")
wpa2=( "pass1" )


for (( i = 0; i < ${#dev[@]}; i++ )); do
  for (( j = 0; j < ${#essid[@]}; j++ )); do
    echo -e "Description='Basic WPA2 profile'\nInterface=${dev[$i]}\nConnection=wireless\nSecurity=wpa\nESSID=${essid[$j]}\nIP=dhcp\nKey=${wpa2[$j]}" > "/etc/netctl/${dev[$i]}-${essid[$j]}-dhcp"
  done
  systemctl enable netctl-auto@${dev[$i]}
done
