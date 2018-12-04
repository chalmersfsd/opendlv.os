# opendlv.os

This repository contains scripts for automated installation of a computer
operating system capable of running the containerized OpenDLV framework.

    Warning!! The scripts will completely erase your entire harddrive (ALL YOUR 
    DATA WILL BE LOST). Do this only if you know exactely what you are doing. 
    Use on your own risk, we are not responsible for any lost data from running 
    these scripts!

## Automated install on a x86 PC

1. Create a Arch Linux bootable USB drive by following the instructions given 
   at: https://wiki.archlinux.org/index.php/USB_flash_installation_media

2. Boot the computer using the bootable USB
3. Connect to the wireless internet via 'wifi-menu' or connect to the wired via 'dhcpcd'
   Check network status with:

   ```
     ip a
   ```

4. Take a note for the name of the network card and the harddrive name you want to install. Will be used later on.
  
   ```
    $ ip a 
    ...
    4: enp10s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    ...
    $ lsblk
    ...
    sda           8:1    0 465.8G  0 disk
    ...
   ```

    remember : Net: enp10s0 , wifi interface : wlp8s0  Disk: hdd: /dev/sda

5. Download the automated scripts with:

   ```
     wget https://raw.githubusercontent.com/cfsd/opendlv.os/master/x86/get.sh
     sh get.sh
   ```
6. Enable the setups that you want to enable on the machine, e.g.:
  if you want the destop and graph card installed:   
   ```
     cp setup-available/setup-post-06-desktop.sh .
   ```
7. Configure the basic installation and the enabled setups. 
   
   Important!! Please check the harddrive device name otherwise you might destroy your working harddrive. Keep/replace the harddrive name you would like to install on if you have more than one harddrive.

   Check the network interface name with 'ip a' and the harddrive device name with 'lsblk'.

   Configure files, e.g:
   change the ```root_password``` ,  ```user_password``` , ```lan_dev```, ```wan_dev```
   ```
     nano install-conf.sh 
   ``` 

8. Run the automated installation with (REMEMBER: all your data will be lost. You have been warned!):

   ```
     chmod +x *.sh
     ./install.sh
   ```
9. After the first computer restart you need to help it once more to get Internet, to finalize the installation. Run wifi-menu again or connect to the wired via 'dhcpcd'

Todo
- update Router-setup

## Automated install on a BeagleBone Black

1. Create a Arch Linux Arm bootable SD card by following the instructions given
   at https://archlinuxarm.org/platforms/armv7/ti/beaglebone-black
2. Boot the BeagleBone Black using the bootable SD card
3. Download the automated scripts with:

   ```
     wget https://raw.githubusercontent.com/chalmers-revere/opendlv.os/master/arm-bbb/get.sh
     sh get.sh
   ```
4. Enable the setups that you want to enable on the machine, e.g.:

   ```
     cp setup-available/setup-post-01-pru.sh .
   ```
5. Configure the basic installation and the enabled setups.

   ```
     vim install-conf.sh
     vim setup-post-01-pru.sh
   ```
6. Run the automated installation with (REMEMBER: all your data will be lost. You have been warned!):

   ```
     chmod +x *.sh
     ./install.sh
   ```
