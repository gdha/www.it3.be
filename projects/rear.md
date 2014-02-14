---
layout: default
title: Relax-and-Recover (rear) Open Source Project
description: An overview of the rear project sponsored by IT3 Consultants
author: gratien
---

## Relax-and-Recover (rear)

<img src="{{ site.url }}/images/logo/rear_logo_100.png" width="50" height="50" alt="Rear logo">

Disasters do happen, big or small, so we better be prepared before these happen. [Relax-and-Recover](http://relax-and-recover.org) is an open source project started in 2006. Rear is in fact the successor of Make CD-ROM Recovery or [mkCDrec]({{ site.url }}/projects/mkcdrec.html) project which went into phasing-out mode in favour of rear.

Commercial Operating Systems ship tools to help you prepare or create images for several years already. However, Linux still lacks a good standard tool delivered with the core system tools (besides tar) to assist with creating a disaster recovery images. As you can image a disaster recovery (DR) exercise is more then just restoring a plain backup.

Rear is a modular disaster recovery engine completely written in bash and released under GPL v2 license. Rear can store the details about your systems on hard disks (network, USB, SAN,...) or network (PXE, NFS, CIFS,...) including the complete backup. It also creates a bootable image which you need to recreate your system from scratch. Furthermore, thanks to the modular concept, we can integrate rear with foreign backup solutions (commercial or not) to do the backup and restore part which makes rear very scalable in big enterprises.

If you are lost or seek for help to setup rear or to add new features into rear we can give you (paid) [rear support offerings]({{ site.url }}/rear-support/)

External link to [Relax-and-Recover](http://relax-and-recover.org/)
