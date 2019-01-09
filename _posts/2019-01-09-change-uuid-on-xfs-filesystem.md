---
layout: post
title: Change the UUID on a xfs file system

description: Change the UUID on a xfs file system

tags: [terminal, AWS, RHEL, linux, howto, it3 consultants]
author: gratien
---

<strong>Change the UUID on a xfs file system</strong>

Amazon EC2 instances based on RHEL tend to have xfs as file system and in some cases when an EC2 instance is not booting anymore we need to move the volume (disk devices) to another instance and mount it over there to troubleshoot.

However, in case the volume is the boot device then the UUID is usually the same on the other EC2 instance so we need to change the UUID before we can mount it.
In the next output you can see for yourself that the UUID of device `/dev/nvme0n1p2` is the same of device `/dev/nvme4n1p2`:

    # blkid
    /dev/nvme0n1p2: UUID="de4def96-ff72-4eb9-ad5e-0847257d1866" TYPE="xfs" PARTUUID="a34cf35b-104d-49b0-ae11-f664a286af07"
    /dev/nvme1n1: UUID="4h9IE7-zHK4-4Syn-5HuK-DKN6-6AT3-MzceG8" TYPE="LVM2_member"
    /dev/nvme2n1: UUID="0d547821-0447-42c1-bda4-22b9139fbd86" TYPE="xfs"
    /dev/nvme0n1: PTTYPE="gpt"
    /dev/nvme0n1p1: PARTUUID="3c387322-88aa-42ba-8c46-ddb0e76f1054"
    /dev/nvme3n1: UUID="e298ceeb-3793-464b-ade8-e5a3e6d0ad66" TYPE="xfs"
    /dev/mapper/docker-259:4-4194383-6f66d0cdd5e610dfaf2788d7d69851c4316f402fcfead7824143262ccde53d4a: UUID="5f8f65da-a304-46ea-a597-79b2fc842113" TYPE="xfs"
    /dev/nvme4n1: PTTYPE="gpt"
    /dev/nvme4n1p1: PARTUUID="3c387322-88aa-42ba-8c46-ddb0e76f1054"
    /dev/nvme4n1p2: UUID="de4def96-ff72-4eb9-ad5e-0847257d1866" TYPE="xfs" PARTUUID="a34cf35b-104d-49b0-ae11-f664a286af07"

And, if we try to mount device `/dev/nvme4n1p2` we will get an error like:

    # mount /dev/nvme4n1p2 /mnt
    mount: wrong fs type, bad option, bad superblock on /dev/nvme4n1p2,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

So, we need to put a new UUID on that device `/dev/nvme4n1p2` and we cannot use `tune2fs` as this can only handle ext-based file systems. We need to use `xfs_admin` instead.

    # uuidgen
    287d622b-f7d2-4ef8-a266-25522426ca84
    # xfs_admin  -U 287d622b-f7d2-4ef8-a266-25522426ca84 /dev/nvme4n1p2
    ERROR: The filesystem has valuable metadata changes in a log which needs to
    be replayed.  Mount the filesystem to replay the log, and unmount it before
    re-running xfs_admin.  If you are unable to mount the filesystem, then use
    the xfs_repair -L option to destroy the log and attempt a repair.
    Note that destroying the log may cause corruption -- please attempt a mount
    of the filesystem before doing this.

Ah, seems we first need to run the `xfs_pair` command:

    # xfs_repair -L /dev/nvme4n1p2
    Phase 1 - find and verify superblock...
    Phase 2 - using internal log
            - zero log...
    ALERT: The filesystem has valuable metadata changes in a log which is being
    destroyed because the -L option was used.
            - scan filesystem freespace and inode maps...
    sb_ifree 1254, counted 1192
    sb_fdblocks 3240095, counted 3240077
            - found root inode chunk
    Phase 3 - for each AG...
    ...
    Phase 7 - verify and correct link counts...
    resetting inode 246 nlinks from 2 to 3
    Metadata corruption detected at xfs_dir3_block block 0x1e36658/0x1000
    libxfs_writebufr: write verifer failed on xfs_dir3_block bno 0x1e36658/0x1000
    Maximum metadata LSN (772:2803) is ahead of log (1:2).
    Format log to cycle 775.
    releasing dirty buffer (bulk) to free list!done

Now we can retry to change the UUID on the device:

    # xfs_admin  -U 287d622b-f7d2-4ef8-a266-25522426ca84 /dev/nvme4n1p2
    Clearing log and setting UUID
    writing all SBs
    new UUID = 287d622b-f7d2-4ef8-a266-25522426ca84

Check if the new UUID was correctly added and try to mount the device:

    # blkid /dev/nvme4n1p2
    /dev/nvme4n1p2: UUID="287d622b-f7d2-4ef8-a266-25522426ca84" TYPE="xfs" PARTUUID="a34cf35b-104d-49b0-ae11-f664a286af07"
    # mount -t xfs /dev/nvme4n1p2 /mnt

Finallly, we can start digging into the content of the device mount on `/mnt` and do whatever was required.
Perhaps, one note if this device will be moved back to the original EC2 instance do not forget to updat the `/mnt/etc/fstab` file with the updated UUID of this modified boot device.

Hope you enjoyed this artice.
regards, Gratien
