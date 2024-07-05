---
layout: post
title: Internal disk was recognized as a multipath device
description:
tags: [terminal, Linux, rear, SLES, multipath, wwids, RHEL, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Internal disk was recognized as a multipath device and as a result no backup was created by rear</strong>

When running `rear mkbackup` it is always important to inspect the rear.log file to see if nothing went wrong. In one of the cases we noticed that the backup time and size was almost zero, where we expected a few GBytes of backup. That was strange as you can see:

    2015-11-09 19:04:58 Creating tar archive '/tmp/rear.lvktayoP8xrcgaK/outputfs/SystemA/backup.tar.gz'
    2015-11-09 19:05:01 Archived 0 MiB in 2 seconds [avg 62 KiB/sec]
    `/tmp/rear.lvktayoP8xrcgaK/tmp/backup.log' -> `/tmp/rear.lvktayoP8xrcgaK/outputfs/SystemA/backup.log'

That was not what we like to see. There must be a reason for it, no? When we saw the content of the `/var/lib/rear/layout/disklayout.conf` file we noticed that all devices were commented out. Also, the internal ones and that should not be the case. Only multipath devices are excluded by default. That made us believe that the internal disks were recognized as multipath devices somehow.

    # cat /var/lib/rear/layout/disklayout.conf
    #disk /dev/sda 600093712384 gpt
    #part /dev/sda 2101248 1048576 legacy bios_grub /dev/sda1
    #part /dev/sda 209719296 4194304 UEFI boot /dev/sda2
    #part /dev/sda 209719296 216006656 lxboot none /dev/sda3
    #part /dev/sda 324799752704 427819008 lxroot none /dev/sda4
    #part /dev/sda 274865266176 325228429312 lxswap none /dev/sda5
    #disk /dev/sdaa 1073741824000
    #disk /dev/sdab 1610612736000
    #disk /dev/sdac 799937658880
    #disk /dev/sdad 1073741824000
    #disk /dev/sdae 1610612736000
    #disk /dev/sdaf 1073741824000
    #disk /dev/sdag 1610612736000
    #disk /dev/sdah 799937658880
    #disk /dev/sdai 1073741824000
    #disk /dev/sdaj 1610612736000
    #disk /dev/sdak 1073741824000
    #disk /dev/sdal 1610612736000
    #disk /dev/sdam 799937658880
    #disk /dev/sdan 1073741824000
    #disk /dev/sdao 1610612736000
    #disk /dev/sdap 1073741824000
    #disk /dev/sdb 800132521984 gpt
    #part /dev/sdb 800132169728 262144 primary none /dev/sdb1
    <snip-snip>
    
All our disk devices are commented out. So, nothing was kept to make the backup of...which explains the 0 sized backup.

As we suspect the internal disk was falsely identified as a multipath device. We should be able to proof it, no?
We know that the World Wide Unique Identifier (WWID) of a multipath device is listed in the `/etc/multipath/wwids` file.

How do we find the WWIDs in use so we can compare the actual list with the content of that file?

We can check the wwid from each device as follow:

    # for MP in $(pvdisplay | grep "PV Name" | cut -d/ -f2-)
      do
        /lib/udev/scsi_id --page=0x83 --whitelisted --device=/$MP
      done
    3600508b1001c0ef5d65e172723b22341
    360002ac0000000000000001500005911
    360002ac0000000000000001400005911
    360002ac0000000000000001d00005911
    360002ac0000000000000001100005911
    360002ac0000000000000001000005911
    

Only the above listed WWIDs may be listed in the `/etc/multipath/wwids` file:


    # cat /etc/multipath/wwids
    # Multipath wwids, Version : 1.0
    # NOTE: This file is automatically maintained by multipath and multipathd.
    # You should not need to edit this file in normal circumstances.
    #
    # Valid WWIDs:
    /3600508b1001ca38a67aac1216518f7fa/
    /3600508b1001c0ef5d65e172723b22341/
    /360002ac0000000000000001000005911/
    /360002ac0000000000000001100005911/
    /360002ac0000000000000001d00005911/
    /360002ac0000000000000001400005911/
    /360002ac0000000000000001500005911/
    
If you have the `fibreutils` rpm package installed then you also have the `scsi_info` command that can be used to show what kind of device we are dealing with.
As we can see the first WWID listed in the `/etc/multipath/wwids` file is from /dev/sda.

To resolve this we must remove the first line in `/etc/multipath/wwids` file and rebuild the kernel (in our case this was a SLES 11 SP3 system).

It is a good practive to make a copy of the original file:

    # cp -p /etc/multipath/wwids /root/wwids.$(date '+%d-%B-%Y')
    # ll /root/wwid*
    -rw------- 1 root root 262 Nov 17 17:35 /root/wwids.17-November-2015
    
    # uname -r
    3.0.101-0.47.52-default
    

Make a copy of the ramdisk too before rebuilding:

    # cd /boot
    # cp -p initrd-$(uname -r) initrd-$(uname -r).$(date '+%d-%B-%Y')
    # ll initrd*
    lrwxrwxrwx 1 root root       30 Oct  8 14:32 initrd -> initrd-3.0.101-0.47.67-default
    -rw-r--r-- 1 root root  9989494 Oct  8 14:32 initrd-3.0.101-0.47.67-default
    -rw------- 1 root root 13265108 Oct  8 14:32 initrd-3.0.101-0.47.67-default-kdump
    -rw-r--r-- 1 root root  9989494 Oct  8 14:32 initrd-3.0.101-0.47.67-default.17-November-2015

    # mkinitrd -k /boot/vmlinuz-$(uname -r) -i /boot/initrd-$(uname -r)

    Kernel image:   /boot/vmlinuz-3.0.101-0.47.67-default
    Initrd image:   /boot/initrd-3.0.101-0.47.67-default
    KMS drivers:     mgag200
    Root device:    /dev/disk/by-id/scsi-3600508b1001c21243dfbae7a6de59c70-part3 (/dev/sda3) (mounted on / as ext3)
    Resume device:  /dev/disk/by-id/scsi-3600508b1001c21243dfbae7a6de59c70-part2 (/dev/sda2)
    Kernel Modules: hwmon thermal_sys thermal processor fan scsi_mod hpsa crc-t10dif scsi_tgt scsi_transport_fc lpfc scsi_dh scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac scsi_dh_alua mbcache jbd ext3 syscopyarea i2c-core sysfillrect sysimgblt i2c-algo-bit drm drm_kms_helper ttm mgag200 usb-common usbcore ohci-hcd uhci-hcd ehci-hcd xhci-hcd hid usbhid sd_mod
    Features:       acpi kms block usb resume.userspace resume.kernel
    Bootsplash:     SLES (1024x768)
    51517 blocks
    >>> Network: auto
    >>> Calling mkinitrd -k /boot/vmlinuz-3.0.101-0.47.67-default -i /tmp/mkdumprd.dZDoqCQJcI -f 'kdump network' -B  -s ''
    Regenerating kdump initrd ...
    
    Kernel image:   /boot/vmlinuz-3.0.101-0.47.67-default
    Initrd image:   /tmp/mkdumprd.dZDoqCQJcI
    KMS drivers:     mgag200
    Root device:    /dev/disk/by-id/scsi-3600508b1001c21243dfbae7a6de59c70-part3 (/dev/sda3) (mounted on / as ext3)
    Resume device:  /dev/disk/by-id/scsi-3600508b1001c21243dfbae7a6de59c70-part2 (/dev/sda2)
    Kernel Modules: hwmon thermal_sys thermal processor fan scsi_mod hpsa crc-t10dif scsi_tgt scsi_transport_fc lpfc scsi_dh scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac scsi_dh_alua mbcache jbd ext3 syscopyarea i2c-core sysfillrect sysimgblt i2c-algo-bit drm drm_kms_helper ttm mgag200 usb-common usbcore ohci-hcd uhci-hcd ehci-hcd xhci-hcd hid usbhid af_packet bonding pps_core ptp tg3 nls_utf8 hpwdt sd_mod
    Firmware:       tigon/tg3_tso5.bin tigon/tg3_tso5.bin.sig tigon/tg3_tso.bin tigon/tg3_tso.bin.sig tigon/tg3.bin tigon/tg3.bin.sig
    Features:       acpi kms block usb network resume.userspace resume.kernel kdump
    68390 blocks
    
In case it would have been a RHEL system then we should use `dracut` (in stead of `mkinitrd`) to rebuild the kernel. However, the principle stays the same.

After the kernel has been rebuild you still need to verify the device names used in `/etc/fstab`,  `grub.conf` or `elilo.conf` need to be modified to the ones shown during the `mkinitrd` command run.

Reboot the system when it is convenient (don't wait too long). However, it is important to inspect the system after the reboot.
If something went wrong you probably be thrown into single user mode where you get the chance to fix whatever went wrong.

At last you can re-run `rear mkbackup` again which now should be able to create a successful archive.

Gratien

Related links:

* [Ignore local disk when generating multipath devices](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/DM_Multipath/ignore_localdisk_procedure.html)
* [Setting up DM-Multipath Overview](https://help.ubuntu.com/lts/serverguide/multipath-setting-up-dm-multipath.html)
* [Relax-and-Recover](http://relax-and-recover.org)

