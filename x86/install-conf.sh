#!/bin/bash

# Basic
hostname=revere-lynx-x86_64

root_password=changeMeNow

timezone=Europe/Stockholm
locale=( en_US.UTF-8 )
mirror=( Sweden )
keymap=sv-latin1

# Users
user=( cfsd )
user_password=( changeMeNow )
group=( uucp )

# Software configuration
software="base-devel gnu-netcat vim ifplugd wget openssh bash-completion git cmake ccache screen wpa_supplicant wpa_actiond dosfstools ntfs-3g linux-headers dialog"
service=( sshd )

# Network
lan_dev = ( enp10s0 )
wan_dev = ( wlp8s0 ) 
dhcp_dev= ( ${lan_dev} )

# Partitions
hdd=/dev/sda

uefi=false
if [ -d "/sys/firmware/efi/efivars" ]; then
  uefi=true
  uefi_bad_impl=true
fi

for f in setup-chroot-*.sh; do
    [ -e "$f" ] && has_setup_chroot=1 || has_setup_chroot=0
    break
done

for f in setup-post-*.sh; do
    [ -e "$f" ] && has_setup_post=1 || has_setup_post=0
    break
done

for f in setup-user-*.sh; do
    [ -e "$f" ] && has_setup_user=1 || has_setup_user=0
    break
done

has_setup_root=$(( $has_setup_chroot || $has_setup_post ? 1 : 0))
has_setup=$(( $has_setup_root || $has_setup_user ? 1 : 0))
