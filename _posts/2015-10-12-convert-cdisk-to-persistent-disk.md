---
layout: post
title: Convert cluster-wide disks to persistent disks on HP-UX 11.31
description:
tags: [terminal, HP-UX, Volume group, LVM, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Convert cluster-wide disks to persistent disks on HP-UX 11.31</strong>

The cluster-wide device special files (cDSFs) are used on HP-UX 11.31 systems together with Serviceguard A.11.20 (or higher) 
cluster nodes to make our lives easier so that on all nodes we see the same device files (e.g. `/dev/cdisk/disk01`). However,
there is a serious drawback with the `sar` utility which cannot distinguish between device `/dev/cdisk/disk01` and `/dev/disk/disk01`.
Furthermore, we have noticed that operational teams add new disks most of the times not as cluster-wide disks and therefore, we get a mix of persistent device files and cluster-wide device files which is not very nice.

This is a small procedure to get rid of the cluster-wide device files. 

In an existing cluster with volume groups using cdisk it is better to shut down the cluster first before starting the migration procedure.

The second step is to activate these cluster aware volume groups manually:

    # vgchange  -c n /dev/vgsap
    # vgchange  -a y /dev/vgsap
    # vgdisplay -v /dev/vgsap | grep "PV Name"
       PV Name                     /dev/cdisk/disk6

As you can see in above example there is still one cdisk in use. To convert this to a persistent disk we use the `vgcdsf` 
LVM utility, which is standard available on HP-UX 11.31. The `vgcdsf` command is LVM tool to convert persistent DSFs in 
a volume group to their corresponding cluster DSFs or vice versa. The `-r` option is necessary to convert cDSF disks to DSF disks.
*Important note*: if a volume group contains a combination of cDSF and persistent disks only the cDSF disks are converted to persistent disks.

    # vgcdsf -r /dev/vgsap
    Successfully converted cluster DSF(s) in Volume Group /dev/vgsap.
    # vgdisplay -v /dev/vgsap | grep "PV Name"
       PV Name                     /dev/disk/disk18

We can see that the cluster-wide disk has been renamed to its persistent disk counter-part. However, the procedure is not yet
completed as the cluster-wide device is still visible by `xpinfo`, `evainfo`, `HP3ParInfo` or `ioscan` tools:

    # ioscan -funNC disk
    Class     I  H/W Path  Driver S/W State   H/W Type     Description
    ===================================================================
    disk      8  64000/0xfa00/0x1   esdisk   CLAIMED     DEVICE       HP      EG0300FAWHV
                          /dev/disk/disk8      /dev/disk/disk8_p2   /dev/rdisk/disk8     /dev/rdisk/disk8_p2
                          /dev/disk/disk8_p1   /dev/disk/disk8_p3   /dev/rdisk/disk8_p1  /dev/rdisk/disk8_p3
    disk      9  64000/0xfa00/0x2   esdisk   CLAIMED     DEVICE       HP      EG0300FAWHV
                          /dev/disk/disk9      /dev/disk/disk9_p2   /dev/rdisk/disk9     /dev/rdisk/disk9_p2
                          /dev/disk/disk9_p1   /dev/disk/disk9_p3   /dev/rdisk/disk9_p1  /dev/rdisk/disk9_p3
    disk     17  64000/0xfa00/0xb   esdisk   CLAIMED     DEVICE       HP      OPEN-V
                          /dev/cdisk/disk5   /dev/disk/disk17   /dev/rcdisk/disk5  /dev/rdisk/disk17
    disk     18  64000/0xfa00/0xc   esdisk   CLAIMED     DEVICE       HP      OPEN-V
                          /dev/cdisk/disk6   /dev/disk/disk18   /dev/rcdisk/disk6  /dev/rdisk/disk18


To get rid of the cluster-wide device we should run the following set of commands:

    # for dsk in $(ls /dev/cdisk)
      do
        rmsf /dev/rcdisk/$dsk
        rmsf /dev/cdisk/$dsk
      done

In case the volume group `vglock` contains a cDSF disk then we need to convert the cDSF disk to a persistent disk as
described above and then reconfigure the cluster configuration with the persistent Serviceguard lock device name.
Do not forget to run `cmcheckconf` and `cmapplyconf` commands to validate and apply the updated cluster configuration.

Also, do not forget to make the volume groups cluster aware again (use the commands `vgchange -c y VG`).
At last, you can restart the cluster again and all cluster-wide devices are now converted to persistent devices.
