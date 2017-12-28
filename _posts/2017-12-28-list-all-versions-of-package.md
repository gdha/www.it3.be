---
layout: post
title: List all versions of a package

description: List all versions of a package

tags: [terminal, yum, rpm, linux, howto, it3 consultants]
author: gratien
---

<strong>List all versions of a package</strong>

It might be interesting to know how many different versions of a given package are available to install, no? We just had a use case for `rear`. Suppose we want to install ReaR release 2.2 and _not_ the most recent one. How do we know it is available to install?

On *RedHat* alike Linux distributions it can be done as follow:

    # yum --showduplicates list rear | expand
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
     * base: be.mirror.guru
     * epel: fr.mirror.babylon.network
     * extras: mirror.plusserver.com
     * updates: centos.mirrors.ovh.net
    Available Packages
    rear.x86_64   1.17.2-1.el7                        Archiving_Backup_Rear         
    rear.x86_64   1.18-3.el7                          Archiving_Backup_Rear         
    rear.x86_64   1.19-2.el7                          Archiving_Backup_Rear         
    rear.x86_64   2.00-1.el7                          Archiving_Backup_Rear         
    rear.x86_64   2.00-2.el7                          base                          
    rear.x86_64   2.00-3.el7_4                        updates                       
    rear.x86_64   2.1-2.el7                           Archiving_Backup_Rear         
    rear.x86_64   2.2-5.el7                           Archiving_Backup_Rear         
    rear.x86_64   2.3-1.el7                           Archiving_Backup_Rear         
    rear.x86_64   2.3-11.git.0.952e698.unknown.el7    Archiving_Backup_Rear_Snapshot

Wow - really a bunch of possibilities are available to install! Haha, the `2.2-5.el7` version is available and that is the release we wanted to test out:

    # yum install rear-2.2-5.el7

Note: if `rear` package was already installed then `yum install` won't work for older versions. You better remove the old version first.

Reference:

- [YUM Cheat Sheet (pdf file)](https://access.redhat.com/sites/default/files/attachments/rh_yum_cheatsheet_1214_jcs_print-1.pdf)
