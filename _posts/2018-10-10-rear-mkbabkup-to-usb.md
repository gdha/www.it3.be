---
layout: post
title: Relax-and-Recover make backup to USB device

description: Relax-and-Recover make backup to USB device

tags: [terminal, vagrant, SLES, linux, howto, it3 consultants]
author: gratien
---

<strong>Relax-and-Recover make backup to USB device</strong>

Making a disaster recovery image of your Linux system to an USB device is quite handy as you can store this USB device (or stick) to an external safe (or whatever). Furthermore, it is also one of the simplest configuration set-ups with Relax-and-Recover (ReaR).

It is of course important that ReaR itself is installed, or via the Linux distribution repositories (if in there like it is with SuSe and Red Hat), or via the ReaR project [Download pages](http://relax-and-recover.org/download/).

Secondly, the USB device need to be inserted the system, and when it is the first time used with ReaR itself it needed to be formatted. Be aware, that formatting will wipe all previous content of this USB device - so think twice!

Suppose that the USB device was discovered as `/dev/sdb` then to format just type:

     # rear format /dev/sdb

If you take the time to look in the `/var/log/rear/rear-$(hostname).log` file you will find the evidence of the format action:

    2018-10-18 10:07:55 Including format/USB/default/35_label_usb_disk.sh
    2018-10-18 10:07:55 Device '/dev/sdb1' has label

The label is by default *REAR-000*

Now, edit the `/etc/rear/local.conf` configuration file of ReaR and add the following lines:

    OUTPUT=USB
    BACKUP=NETFS
    BACKUP_URL="usb:///dev/disk/by-label/REAR-000"

Alright, that should be enough to start with. Let us kick off ReaR by typing:

    # rear -v mkbackup

Oops, we are thrown out with an error:

    Mount command 'mount -v -o rw,noatime /dev/disk/by-label/REAR-000 /tmp/rear.DSVwMzsC3UtrSaJ/outputfs' failed.

Like always first check the log file of ReaR again as sometimes the real error is shown in there:

    018-10-18 10:09:11 Including prep/NETFS/default/06_mount_NETFS_path.sh
    mkdir: created directory ‘/tmp/rear.DSVwMzsC3UtrSaJ/outputfs’
    2018-10-18 10:09:11 Mounting with 'mount -v -o rw,noatime /dev/disk/by-label/REAR-000 /tmp/rear.DSVwMzsC3UtrSaJ/outputfs'
    mount: you must specify the filesystem type
    mount: you didn't specify a filesystem type for /dev/disk/by-label/REAR-000
       I will try all types mentioned in /etc/filesystems or /proc/filesystems
    2018-10-18 10:09:11 ERROR: Mount command 'mount -v -o rw,noatime /dev/disk/by-label/REAR-000 /tmp/rear.DSVwMzsC3UtrSaJ/outputfs' failed.

Hum, no extra information found. So what now?
As we trying to mount the USB device with a label the first thing to do is to check if the label is shown on this system:

    # ls -l /dev/disk/by-label/
    ls: cannot access /dev/disk/by-label/: No such file or directory

That is the reason why it failed. Do not despaire as we know that the USB device was formatted as `/dev/sdb1`, therefore, we can use this in the configuration file of ReaR. Edit the `/etc/rear/local.conf` file and adapt:

    BACKUP_URL=usb:///dev/sdb1

Now, try again with the command `rear -v mkbackup` and now it works fine. After a successful backup of the ReaR image eject the USB device and store it away.

## References

 - [Relax-and-Recover](http://relax-and-recover.org/)
