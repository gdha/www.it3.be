---
layout: post
title: SANmigration
description:
tags: [terminal, HP-UX, StorageArray XP, LVM, script, ksh, tutorial, howto, it3 consultants]
author: gratien
---

<strong>SANmigration: recreate the VGs, Lvols, file systems via scripting</strong>

I never thought that the 4 years old scripts would become of use again! It was a life saver. Let me explain...

We needed to migrate an older HP-UX system from one data center to another without physical moving the hardware. Therefore, we used a free system in the destination data center and re-ignited the operating system (re-install vg00 of the source system). That fixed the bare HP-ux operating system. However, the source system had 2 volume groups (VGs) located on a HP StorageArray XP9500 and we also needed to copy over the data. As you know recreating the volume groups and logical volumes and file systems are a work intensive job where mismake are easily made.

At that moment in time I realized I wrote some scripts to do exactly the same 4 years ago to recreate an exact copy of the VGs and so on of systems located in a remote data center which needed to be migarted via tapes (it was from an external party). Therefore, I decided to give it a try.

First of all grab the sources of the script [1] and install it somewhere on the source and target system. An important note is that the target system needs to have SAN storage available (amount of physical disks needs to be equal or more, and the size of the disks should be in the neighorhood of the original sizing).

On the source system you just need to run the script:

    #-> ./save_san_layout.sh
    ###############################################################################################
      Installation Script: save_san_layout.sh
         Script Arguments: default values
                  Purpose: Save the current SAN configuration file (SAN_layout_of_hpx217.conf)
               OS Release: 11.23
                    Model: ia64
        Installation Host: hpx217
        Installation User: root
        Installation Date: 2016-05-11 @ 08:23:17
         Installation Log: /var/adm/install-logs/save_san_layout.scriptlog
    ###############################################################################################
     ** Running on HP-UX 11.23
     ** Created temporary directory /tmp/sana21855
     ** Saving ioscan output of disks as /tmp/sana21855/ioscan.out
    Progress:
    Total wait time: 0 second(s)
    --------------
    
     ** Storage box in use is of type xp
     ** Saving xpinfo output as /tmp/sana21855/xpinfo.out
    Progress: *
    Total wait time: 3 second(s)
    --------------
    
     ** Saved /etc/lvmtab as /tmp/sana21855/lvmtab.out
     ** No Physical Volume Groups (PVGs) active on system hpx217
     ** Analyzing disk /dev/rdsk/c14t0d0
     ...
     ** Analyzing disk /dev/rdsk/c14t0d5
     ** Analyzing physical volume /dev/dsk/c14t0d0
     ...
     ** Analyzing physical volume /dev/dsk/c14t0d5
     ** Analyzing Volume group /dev/vg01
     ** Analyzing Volume group /dev/vg_APPQ
     ** Analyzing logical Volume /dev/vg01/lvappjava
     ** Analyzing logical Volume /dev/vg_APPQ/lv_APPQcime
     ...
     ** Analyzing mount point /appjava (lvol /dev/vg01/lvappjava)
     ** Analyzing mount point /opt/APPQcime (lvol /dev/vg_APPQ/lv_APPQcime)
     ...
     ** Removed temporary directory /tmp/sana21855
    Save the SANCONF=/tmp/SAN_layout_of_hpx217.conf file at a safe place.
    Done.

I removed quite a few lines from the above output for brievity. The configuration file created by this script (`/tmp/SAN_layout_of_hpx217.conf`) needs to be copied to the target system.

On the target system you must have the the configuration file created (of the source system). This file contains a description of all physical disks, volume groups, logical volumes and file systems that need to be recreated on this target system. This is done in a two-way approach. We run a script which analyses the target system StorageArray and proposes the new disk to be used. We can edit this and when pleased confirm and let this script run to create a *new* script. This new script can be reviewed, adapted and so on until we are happy with it. Then we just need to run it to recreate all file systems on the target system.

First, some words on the script `create_san_layout_script.sh` - it has an usage which is helpful:

    #-> ./create_san_layout_script.sh -?
    Usage: create_san_layout_script.sh [-f SAN_layout_configuration_file] [-s create_SAN_layout.sh] [-p percentage] [-k] [-h] [-d]
    
    -f file:   The SAN_layout_configuration_file containing the SAN layout of hpx208bi
    -s script: The name of the SAN creation script
    -p nr:     A percentage (integer) value which is allowed in deviation of the target disk sizes
    -k:        Keep the temporary directory after we are finished executing create_san_layout_script.sh
    -h:        Show usage [this page]
    -d:        Enable debug mode (by default off)


There is only one mandatory parameter (`-f file`), all the others are optional. OK, just try it out:

    #-> ./create_san_layout_script.sh -f ./SAN_layout_of_hpx217.conf
    ###############################################################################################
      Installation Script: create_san_layout_script.sh
         Script Arguments: -f ./SAN_layout_of_hpx217.conf
                  Purpose: Create the SAN creation script (make_SAN_layout_of_hpx208bi.sh)
               OS Release: 11.23
                    Model: ia64
        Installation Host: hpx208bi
        Installation User: root
        Installation Date: 2016-05-11 @ 09:37:44
         Installation Log: /var/adm/install-logs/create_san_layout_script-2016-May-11-09h37m.scriptlog
    ###############################################################################################
     ** Running on HP-UX 11.23
     ** Created temporary directory /tmp/sana22244
     ** Force an ioscan and search for new disks
    Progress: **
    Total wait time: 6 second(s)
    --------------
    
     ** Reinstalling special files for disks only
     ** Saving ioscan output of disks as /tmp/sana22244/ioscan.out
    Progress: *
    Total wait time: 3 second(s)
    --------------
    
     ** Saving xpinfo output as /tmp/sana22244/xpinfo.out
    Progress: **
    Total wait time: 6 second(s)
    --------------
    
     ** Building the free disks list (made from xpinfo.out file)
     ** Analyzing disk /dev/rdsk/c10t0d0
     ** Analyzing disk /dev/rdsk/c8t0d0
     ** Analyzing disk /dev/rdsk/c6t0d0
     ** Analyzing disk /dev/rdsk/c4t0d0
     ....
     ** Creating disk mapping file /tmp/sana22244/diskmap
     *** WARN: Try reducing the deviation 5, e.g. create_san_layout_script.sh -p 4
     *** ERROR: No free disk left anymore with size 67108864 kB /tmp/sana22244/freedisks
     *** ERROR: Oops - 1 error(s) were encounterd by create_san_layout_script.sh on hpx208bi

I suppose we were too optmistic! We need to edit the configuration file a bit so it matches the amount of disks.

I reran the script with debugging and keep options:

    #-> ./create_san_layout_script.sh -f ./SAN_layout_of_hpx217.conf -k -d

It spawns a lot of output, but

     ** Successfully created the disk mapping file /tmp/sana29087/diskmap
     ** The /tmp/sana29087/diskmap file prepared looks like:
    # old_disk new_disk
    /dev/rdsk/c12t0d0 /dev/rdsk/c10t0d0
    /dev/rdsk/c12t0d1 /dev/rdsk/c8t0d0
    /dev/rdsk/c12t0d2 /dev/rdsk/c6t0d0
    /dev/rdsk/c12t0d3 /dev/rdsk/c4t0d0
    /dev/rdsk/c12t0d4 /dev/rdsk/c10t0d1
    /dev/rdsk/c12t0d5 /dev/rdsk/c8t0d1
    /dev/rdsk/c14t0d0 /dev/rdsk/c6t0d1
    /dev/rdsk/c14t0d1 /dev/rdsk/c4t0d1
    /dev/rdsk/c14t0d2 /dev/rdsk/c10t0d2
    /dev/rdsk/c14t0d3 /dev/rdsk/c8t0d2
    /dev/rdsk/c14t0d4 /dev/rdsk/c4t0d2
    /dev/rdsk/c14t0d5 /dev/rdsk/c6t0d2
    Do you want to edit /tmp/sana29087/diskmap Y/n ? 

What I did is using another window to edit `/tmp/sana29087/diskmap` by hand as the directory `/tmp/sana29087` contained also the `ioscan` and `xpinfo` output which was convenient to map the proper disk devices (with the original sources). When I was please I went back the first window and type **n** to continue.
A lot of output flows by, but the end is interesting:

     ** Do not forget to execute "rm -rf /tmp/sana29087" afterwards.
     Inspect script /home/gdhaese1/projects/SANmigration/make_SAN_layout_of_hpx208bi.sh before executing it!
     ** No errors were encountered by create_san_layout_script.sh on hpx208bi

The script `create_san_layout_script.sh` generated a new script `make_SAN_layout_of_hpx208bi.sh` which we can inspect, modify and so on before running it.

Run the newly created script:

    #->  /home/gdhaese1/projects/SANmigration/make_SAN_layout_of_hpx208bi.sh -f ./SAN_layout_of_hpx217.conf
    ...
    Physical volume "/dev/rdsk/c10t0d4" has been successfully created.
     ** Exec: pvcreate -f /dev/rdsk/c4t0d4
    Physical volume "/dev/rdsk/c4t0d4" has been successfully created.
     ** Directory /dev/vg01 already exist
     ** Exec: mknod /dev/vg01/group c 64 0x010000
    mknod: File exists
    mknod /dev/vg01/group failed. Do you want to continue y/N ? y
    Y
     ** Created /dev/vg01/group with major nr (64) and minor nr (0x010000)
     ** vgcreate -l 255 -s 8 -p 64 -e 10000  /dev/vg01 /dev/dsk/c10t0d0
    vgcreate: Not enough physical extents per physical volume.
     Need: 12800, Have: 10000.
    vgcreate of /dev/vg01 failed. Do you want to continue y/N ?
    N
     ** Fix the error and retry...
     *** ERROR: Oops - 1 error(s) were encounterd by make_SAN_layout_of_hpx208bi.sh on hpx208bi

Ok, we got it. Modify the script as demanded...and retry:

    #->  /home/gdhaese1/projects/SANmigration/make_SAN_layout_of_hpx208bi.sh -f ./SAN_layout_of_hpx217.conf
    ...
     ** Exec: pvcreate -f /dev/rdsk/c4t0d0
    Physical volume "/dev/rdsk/c4t0d0" has been successfully created.
    ...
     ** Exec: mkdir -p -m 755 /dev/vg01
     ** Exec: mknod /dev/vg01/group c 64 0x010000
     ** Created /dev/vg01/group with major nr (64) and minor nr (0x010000)
     ** vgcreate -l 255 -s 8 -p 64 -e 12800  /dev/vg01 /dev/dsk/c10t0d0
    Volume group "/dev/vg01" has been successfully created.
    Volume Group configuration for /dev/vg01 has been saved in /etc/lvmconf/vg01.conf
     ** Exec: vgextend  /dev/vg01 /dev/dsk/c10t0d1
    Volume group "/dev/vg01" has been successfully extended.
    Volume Group configuration for /dev/vg01 has been saved in /etc/lvmconf/vg01.conf
    ...
     ** Exec: lvcreate  -r N -n mws8 /dev/vg01
    Logical volume "/dev/vg01/mws8" has been successfully created with
    character device "/dev/vg01/rmws8".
    Volume Group configuration for /dev/vg01 has been saved in /etc/lvmconf/vg01.conf
     ** Exec: lvextend -l 640 /dev/vg01/mws8
    ...
    Volume Group configuration for /dev/vg_APPQ has been saved in /etc/lvmconf/vg_APPQ.conf
     ** Exec: lvextend -l 63 /dev/vg_APPQ/lv_APPQcime
    Logical volume "/dev/vg_APPQ/lv_APPQcime" has been successfully extended.
    Volume Group configuration for /dev/vg_APPQ has been saved in /etc/lvmconf/vg_APPQ.conf
     ** Exec: mkfs -F vxfs -o bsize=1024 -o largefiles /dev/vg01/rmws8
        version 6 layout
        5242880 sectors, 5242880 blocks of size 1024, log size 16384 blocks
        largefiles supported
     ** Directory /opt/webMethods8 already exist
     ** Exec: chmod 755 /opt/webMethods8
     ** Exec: chown webm7 /opt/webMethods8
     ** Exec: chgrp eadv /opt/webMethods8
    ...
     ** Exec: pvchange  -t 60 /dev/dsk/c4t0d0
    Device file path "/dev/dsk/c4t0d0" is an alternate path
    to the Physical Volume. Using Primary Link "/dev/dsk/c10t0d0".
    Physical volume "/dev/dsk/c10t0d0" has been successfully changed.
    Volume Group configuration for /dev/vg01 has been saved in /etc/lvmconf/vg01.conf
    ...
     ** No errors were encountered by make_SAN_layout_of_hpx208bi.sh on hpx208bi


Hurray! It finished and we have our file systems recreated as they were on the original system.
Just do a mount and verify.

Related links:

* [Sources of SANmigration on GitHub](https://github.com/gdha/SANmigration)
