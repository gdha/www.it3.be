--
layout: post
title: Raspberry Pi timecapsule with Pidora Linux
description:
tags: [terminal, raspberrypi, timecapsule, Linux, pidora, bash, support, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Raspberry Pi timecapsule with Pidora Linux</strong>

After more then two years good service as timecapsule for my Macs we will refurbish the Raspberry Pi for some new tasks. We replace the timecapsule functionality with a brand new Synology NAS system.

We just want to describe here briefly how we did the setup of the Raspberry Pi with Pidora Linux distribution and an external USB drive to capture the backups from the Macs. So, what do we need from hardware perspective? One Raspberry Pi, USB disk drive, an UTP network cable and power. Software needed is the [pidora linux distribution](http://pidora.ca/), but it can be any kind of Linux in my opinion.

After installing pidora according the [instructions](https://wiki.cdot.senecacollege.ca/wiki/Pidora_Installation) we just need to tweek the configuration a bit to make it happen. First of all the external USB disk need to be connected and re-format it with parted in one big partition (Linux filesystem). We labeled it with a 'gpt' disklabel (not 'dos'). We formatted it with an 'ext4' file system.

Then mount it onto directory '/mnt/TimeCapsule', which first must be cerated of course and added an entry in the '/etc/fstab' file:

    /dev/sda1		/mnt/TimeCapsule	ext4	rw,defaults	0 3


    $ rpm -qa --last | head -20

To make the TimeCapsule working we need some extra software packages. We added the following packages (not all really required):

    samba-4.1.9-3.fc20.armv6hl                    Tue Oct  7 21:22:32 2014
    libaio-0.3.109-8.fc20.armv6hl                 Tue Oct  7 21:22:29 2014
    samba-common-4.1.9-3.fc20.armv6hl             Tue Oct  7 21:22:24 2014
    hfsplusutils-1.0.4-19.fc20.armv6hl            Fri Oct  3 13:14:39 2014
    hfsutils-3.2.6-24.fc20.armv6hl                Fri Oct  3 13:14:37 2014
    nss-mdns-0.10-13.fc20.armv6hl                 Fri Sep 26 18:51:26 2014
    avahi-compat-libdns_sd-0.6.31-21.fc20.armv6hl Fri Sep 26 18:51:24 2014
    avahi-tools-0.6.31-21.fc20.armv6hl            Fri Sep 26 18:18:13 2014
    avahi-0.6.31-21.fc20.armv6hl                  Fri Sep 26 18:18:07 2014
    netatalk-2.2.3-9.fc20.armv6hl                 Fri Sep 26 18:14:04 2014
    gnupg-1.4.18-1.fc20.armv6hl                   Fri Sep 26 18:11:04 2014



Then it is just a matter of some configuration tweaks:

    $ cat /etc/default/netatalk 
    ATALKD_RUN=no
    PAPD_RUN=no
    CNID_METAD_RUN=yes
    AFPD_RUN=yes
    TIMELORD_RUN=no
    A2BOOT_RUN=no
    
    
    $ grep -v \# /etc/netatalk/AppleVolumes.default
    :DEFAULT: cnidscheme:dbd options:upriv,usedots,tm allow:gdha
    /mnt/TimeCapsule                       "Time Capsule"
    
    
    $ grep -v \# /etc/netatalk/afpd.conf           
    - -tcp -noddp -uamlist uams_dhx2.so,uams_dhx2_passwd.so   -nosavepassword

Also, make sure the following services are enabled and started via 'systemctl':

    avahi-daemon.service
    avahi-daemon.socket
    netatalk.service

To make things easier for us we disbled SELinux as we used it as an internal solution. Also, make sure the hostname has the extension '.local' as we are avahi to get discovered by the Mac.

On the Mac open the Time Machine application and link your RaspberryPi IP address to it to make it work and login with your account.

External links:

* [Setup TimeCapsule with Ubuntu](https://pwntr.com/2012/03/03/easy-mac-os-x-lion-10-7-time-machine-backup-using-an-ubuntu-linux-server-11-10-12-04-lts-and-up/)
* [Use samba as TimeCapsule](https://www.raspberrypi.org/forums/viewtopic.php?f=41&t=4686&start=25)

