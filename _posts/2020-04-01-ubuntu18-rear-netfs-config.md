---
layout: post
title: Configure ReaR on Ubuntu 18.04 with NETFS

description: Configure ReaR on Ubuntu 18.04 with NETFS

tags: [terminal, relax-and-recover, rear, it3 consultants]
author: gratien
---

<strong>Configure ReaR on Ubuntu 18.04 with NETFS</strong>

On a new laptop with Ubuntu 18.04 Linux distribution we wish to install Relax-and-Recover (ReaR). We decided to use the stable version as provided by the ReaR maintainers, therefore, we created the following file:

    # cat /etc/apt/sources.list.d/rear-stable.list
    deb [arch=amd64] http://download.opensuse.org/repositories/Archiving:/Backup:/Rear/xUbuntu_18.04/ /

Then, run the `apt update` command to refresh the cache.

To install ReaR just run `apt install rear`. Now, we can configure ReaR and edit the `/etc/rear/local.conf` file. In our case we wanted to use NETFS with the creation of an ISO disaster recovery image and store the backup onto our NAS system (called nas).

    # cat /etc/rear/local.conf 
    # Default is to create Relax-and-Recover rescue media as ISO image
    # set OUTPUT to change that
    # set BACKUP to activate an automated (backup and) restore of your data
    # Possible configuration values can be found in /usr/share/rear/conf/default.conf
    #
    # This file (local.conf) is intended for manual configuration. For configuration
    # through packages and other automated means we recommend creating a new
    # file named site.conf next to this file and to leave the local.conf as it is. 
    # Our packages will never ship with a site.conf.
    
    BACKUP=NETFS
    OUTPUT=ISO
    BACKUP_URL=nfs://nas/volume1/RearSpace
    BACKUP_OPTIONS="nfsvers=3,nolock"
    SSH_ROOT_PASSWORD="relax"

Seems that we can give a try:

    # rear -v mkbackup
    Relax-and-Recover 2.5 / 2019-05-10
    Running rear mkbackup (PID 2302)
    Using log file: /var/log/rear/rear-velo.log
    ERROR: Mount command 'mount -v -t nfs -o nfsvers=3,nolock nas:/volume1/RearSpace /tmp/rear.7VetNNJsdhJ3qtO/outputfs' failed.
    Some latest log messages since the last called script 060_mount_NETFS_path.sh:
      2020-04-01 14:03:44.954219764 Including prep/NETFS/default/060_mount_NETFS_path.sh
      mkdir: created directory '/tmp/rear.7VetNNJsdhJ3qtO/outputfs'
      2020-04-01 14:03:44.958863944 Mounting with 'mount -v -t nfs -o nfsvers=3,nolock nas:/volume1/RearSpace /tmp/rear.7VetNNJsdhJ3qtO/outputfs'
      mount: /tmp/rear.7VetNNJsdhJ3qtO/outputfs: bad option; for several filesystems (e.g. nfs, cifs) you might need a /sbin/mount.<type> helper program.
    Aborting due to an error, check /var/log/rear/rear-velo.log for details
    Exiting rear mkbackup (PID 2302) and its descendant processes ...
    Running exit tasks
    Terminated

Hum, NFS mounting did not work. To check the NAS do the following:

    # showmount -e nas
    
    Command 'showmount' not found, but can be installed with:
    
    apt install nfs-common

OK, that is a clear message of what seems to be missing. Install the nfs-common package and retry ReaR.

    # rear -v mkbackup
    Relax-and-Recover 2.5 / 2019-05-10
    Running rear mkbackup (PID 4655)
    Using log file: /var/log/rear/rear-velo.log
    Using backup archive '/tmp/rear.BFnQD5TDM0X4M2C/outputfs/velo/backup.tar.gz'
    Using UEFI Boot Loader for Linux (USING_UEFI_BOOTLOADER=1)
    Using autodetected kernel '/boot/vmlinuz-4.15.0-1076-oem' as kernel in the recovery system
    Creating disk layout
    Docker is running, skipping filesystems mounted below Docker Root Dir /var/lib/docker
    Using guessed bootloader 'EFI' (found in first bytes on /dev/nvme0n1)
    Verifying that the entries in /var/lib/rear/layout/disklayout.conf are correct ...
    Creating root filesystem layout
    Skipping 'docker0': not bound to any physical interface.
    Cannot include default keyboard mapping (no KEYMAPS_DEFAULT_DIRECTORY specified)
    Cannot include keyboard mappings (neither KEYMAPS_DEFAULT_DIRECTORY nor KEYMAPS_DIRECTORIES specified)
    Trying to find what to use as UEFI bootloader...
    Trying to find a 'well known file' to be used as UEFI bootloader...
    Using '/boot/efi/EFI/ubuntu/grubx64.efi' as UEFI bootloader file
    Copying logfile /var/log/rear/rear-velo.log into initramfs as '/tmp/rear-velo-partial-2020-04-01T14:06:13+02:00.log'
    Copying files and directories
    Copying binaries and libraries
    Copying all kernel modules in /lib/modules/4.15.0-1076-oem (MODULES contains 'all_modules')
    Copying all files in /lib*/firmware/
    Symlink '/lib/modules/4.15.0-1076-oem/build' -> '/usr/src/linux-headers-4.15.0-1076-oem' refers to a non-existing directory on the recovery system.
    It will not be copied by default. You can include '/usr/src/linux-headers-4.15.0-1076-oem' via the 'COPY_AS_IS' configuration variable.
    Broken symlink '/etc/ssl/certs/1c7314a2' in recovery system because 'readlink' cannot determine its link target
    Broken symlink '/etc/ssl/certs/0c31d5ce' in recovery system because 'readlink' cannot determine its link target
    Symlink '/usr/share/misc/magic' -> '/usr/share/file/magic' refers to a non-existing directory on the recovery system.
    It will not be copied by default. You can include '/usr/share/file/magic' via the 'COPY_AS_IS' configuration variable.
    Testing that the recovery system in /tmp/rear.BFnQD5TDM0X4M2C/rootfs contains a usable system
    Creating recovery/rescue system initramfs/initrd initrd.cgz with gzip default compression
    Created initrd.cgz with gzip default compression (296744608 bytes) in 25 seconds
    Making ISO image
    Wrote ISO image: /var/lib/rear/output/rear-velo.iso (328M)
    Copying resulting files to nfs location
    Saving /var/log/rear/rear-velo.log as rear-velo.log to nfs location
    Copying result files '/var/lib/rear/output/rear-velo.iso /tmp/rear.BFnQD5TDM0X4M2C/tmp/VERSION /tmp/rear.BFnQD5TDM0X4M2C/tmp/README /tmp/rear.BFnQD5TDM0X4M2C/tmp/rear-velo.log' to /tmp/rear.BFnQD5TDM0X4M2C/outputfs/velo at nfs location
    Creating tar archive '/tmp/rear.BFnQD5TDM0X4M2C/outputfs/velo/backup.tar.gz
    Archived 7790 MiB [avg 9812 KiB/sec] OK
    WARNING: tar ended with return code 1 and below output:
      ---snip---
      tar: 127: Warning: Cannot flistxattr: Operation not supported
      tar: 116: Warning: Cannot flistxattr: Operation not supported
      tar: /sys: file changed as we read it
      ----------
    This means that files have been modified during the archiving
    process. As a result the backup may not be completely consistent
    or may not be a perfect copy of the system. Relax-and-Recover
    will continue, however it is highly advisable to verify the
    backup in order to be sure to safely recover this system.
    
    Archived 7790 MiB in 814 seconds [avg 9800 KiB/sec]
    Exiting rear mkbackup (PID 4655) and its descendant processes ...
    Running exit tasks

Alright, it seems to have worked fine this time. To test the ISO image we should convert the ISO file to a bootable USB stick before we can test it, but that is another story (for a later post).


References:

[1] [Relax-and-Recover (ReaR)](http://relax-and-recover.org/)

[2] [Relax-and-Recover Professional Support](http://www.it3.be/rear-support/)
