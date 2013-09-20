---
layout: post
title: What to do when mount does not work on HP-UX?
description:
tags: [terminal, hpux, HP-UX, tutorial, howto, it3 consultants]
author: gratien
---

<strong>In a HP Serviceguard package log you may find an error "/dev/vgoracle/lvoproracle is already mounted, /opr_oracle is busy"</strong>

As a result the package does not start and fails immediately. What are the steps you can do?

Inspect the log file of the package in more details:

    Sep 18 09:36:48 root@hpnode1 filesystem.sh[12309]: Logical Volume is /dev/vgoracle/lvoproracle
    Sep 18 09:36:48 root@hpnode1 filesystem.sh[12309]: Mounting /dev/vgoracle/lvoproracle with option -o largefiles
    UX:vxfs mount: ERROR: V-3-21264: /dev/vgoracle/lvoproracle is already mounted, /opr_oracle is busy,
                allowable number of mount points exceeded
    Sep 18 09:36:48 root@hpnode1 filesystem.sh[12309]: ERROR: Function sg_check_and_mount
    Sep 18 09:36:48 root@hpnode1 filesystem.sh[12309]: ERROR: Failed to mount /dev/vgoracle/lvoproracle

Perhaps, the file system /opr_oracle was not properly unmounted? Check this with the `mount | grep opr_oracle` command. If it is there then you could try the following (in sequence if necessary):

    umount /opr_oracle
    umount /dev/vgoracle/lvoproracle
    umount -f /opr_oracle
    umount -f /dev/vgoracle/lvoproracle
    
If that does not help then check if there are still some processes running which prevent the file system from unmounting:

    fuser -c /opr_oracle

To kill those processes just use the command `fuser` with option -k:

    fuser -k /opr_oracle
    umount /opr_oracle

A last command to force an unmount is:

    /sbin/fs/vxfs/vxumount -o force /opr_oracle

If all above did not help at help to resolve the start-up of the package then you probably hit the issue mentioned in article: <a href="http://www.symantec.com/business/support/index?page=content&amp;id=TECH125050">Unable mount files system. error v-3-21264</a>. To fix the issue execute the following set of commands:

    # ls /opr_oracle
    # rmdir /opr_oracle
    # ls /opr_oracle
    /opr_oracle not found
    # mkdir -m 755 /opr_oracle
    
    
    # cmrunpkg -n hpnode1 oracle
    Running package oracle on node hpnode1
    Successfully started package oracle on node hpnode1
    cmrunpkg: All specified packages are running
    # bdf /opr_oracle
    Filesystem          kbytes    used   avail %used Mounted on
    /dev/vgoracle/lvoproracle
                        262144    2206  243697    1% /opr_oracle


