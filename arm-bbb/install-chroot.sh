#!/bin/bash

cd
source install-conf.sh

echo ${hostname} > /etc/hostname
ln -fs /usr/share/zoneinfo/${timezone} /etc/localtime

for i in ${locale[@]}; do
  sed -i "s/^#$i/$i/g" /etc/locale.gen
done
locale-gen
echo "LANG=${locale[0]}" > /etc/locale.conf

echo "KEYMAP=${keymap}" > /etc/vconsole.conf

pacman -Syy

pacman -S --noconfirm ${software}

pacman -U --noconfirm --force linux-am33x-4.9.10-1-armv7h.pkg.tar.xz linux-am33x-headers-4.9.10-1-armv7h.pkg.tar.xz

orphans=`pacman -Qtdq`
if [ ! "${orphans}" == "" ]; then
  pacman -Rns ${orphans} --noconfirm || true
fi

echo g_ether > /etc/modules-load.d/g_ether.conf
echo -e "Description='Connection via USB'\nInterface=usb0\nConnection=ethernet\nIP=dhcp" > /etc/netctl/usb0
netctl enable usb0

userdel -r alarm

useradd -m -g users -G wheel aur
echo "aur ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo) 
# TODO: This permission should be removed after installation. Workaround is to remove the user.

for (( i = 0; i < ${#user[@]}; i++ )); do
  useradd -m -g users -s /bin/bash ${user[$i]}
  if [ ! "${group[$i]}" == "" ]; then
    usermod -G ${group[$i]} ${user[$i]}
  fi

  echo -e "${user_password[$i]}\n${user_password[$i]}" | (passwd ${user[$i]})
done

if [ ! "${service}" == "" ]; then
  for s in ${service[@]}; do
    systemctl enable $s
  done
fi

if [ ! "$group" == "" ]; then
  for i in "${group[@]}"; do
    IFS=',' read -a grs <<< "$i"
    for j in "${grs[@]}"; do
      if [ "$(grep $j /etc/group)" == "" ]; then
        groupadd $j
      fi
    done
  done
fi

if [[ $has_setup_chroot == 1 ]]; then
  for f in setup-chroot-*.sh; do
    su -c ./${f} -s /bin/bash root
    cd /root
  done
  rm setup-chroot-*.sh
fi

echo -e "[Unit]\nDescription=Automated install, post setup\nAfter=network-online.target\nRequires=network-online.target\n\n\n[Service]\nType=oneshot\nExecStart=/root/install-post.sh\nWorkingDirectory=/root\n\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/install-post.service

echo -e "WARNING: POST INSTALL IN PROGRESS.\n  The install-post.sh script is running. It will first wait for an active Internet connection. Then it will start running the selected setup scripts. To see the progress, run 'journalctl -u install-post -f'. The computer will be rebooted automatically when the installation is complete!" > /etc/motd

systemctl enable install-post.service

echo -e "${root_password}\n${root_password}" | (passwd)

rm install-chroot.sh && exit
