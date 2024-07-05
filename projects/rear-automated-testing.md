---
layout: default
title: Relax-and-Recover (ReaR) Automated Testing Project
description: An overview of the ReaR Automated Testing project sponsored by IT3 Consultants
author: gratien
---

## Relax-and-Recover (ReaR) Automated Testing

<img src="{{ site.url }}/images/logo/rear_logo_100.png" width="50" height="50" alt="Rear logo">

[Relax-and-Recover]({{ site.url }}/projects/rear/) is our well known open source project dealing with Disaster Recovery of bare metal GNU/Linux systems. 
ReaR is a modular disaster recovery engine completely written in bash and released under GPL v3 license. ReaR can store the details about your systems on hard disks (network, USB, SAN,...) or network (PXE, NFS, CIFS,...) including the complete backup. It also creates a bootable image which you need to recreate your system from scratch. Furthermore, thanks to the modular concept, we can integrate rear with foreign backup solutions (commercial or not) to do the backup and restore part which makes rear very scalable in big enterprises.
Testing such wide range of features on different GNU/Linux distributions such as:

 - RHEL
 - SLES
 - Debian
 - Ubuntu
 - Arch

To name a few and do not forget these distributions supports also different hardware types such as x86_64, ppc64, ppc64le, ia64. Not to mention all the different combinations that are possible how to backup and recover the systems disks with different types of backup mechanism, such as tar, rsync, duplicity, bareos, and many commercial backup solutions.

Summary - testing is a nighmare before we can bring out a new release. We suspect that the end-users of ReaR have no clue of the amount of tests are necessary before we are convinced that a  fresh ReaR release is stable enough to set free.
Above all, you cannot do enough tests, but doing enough tests is not possible due to limited resources (hardware), and hand labour as automating was almost not possible as a disaster recovery exercise needs manual intervention.

This project "[ReaR Automated Testing](https://gdha.github.io/rear-automated-testing/)" wanted to automate as much as possible for a limited set of cases. We started this project for our customers with a valid [ReaR Support contract]({{ site.url }}/rear-support/) as an additional support service. ReaR Automated Testing project is an Open Source project (license based on GPLv3) so that everybody may benefit from it and can freely use it (and/or improve/enhance).

In the past, we did tests on:

 - CentOS 7 with PXE booting and BACKUP=NETFS (using tar and NFS)
 - Ubuntu 14.04 with ISO booting and BACKUP=BAREOS
 - Ubuntu 16.04 with ISO booting and BACKUP=BAREOS

Present time: the project is on-hold due to no funding anymore! Open Source is free as in beer, right? Free does not mean we have to work for free!

If you would like to see your use case being automated tested you need to subscribe for one of the [ReaR support offerings]({{ site.url }}/rear-support/)
Want to know more? Perhaps watch one of the [presentation about ReaR Automated Testing](https://media.ccc.de/v/froscon2017-1957-relax-and-recover_automated_testing).

 - External link to [ReaR Automated Testing Documentation](https://gdha.github.io/rear-automated-testing/)
 - External link to [ReaR Automated Testing GitHub Sources](https://github.com/gdha/rear-automated-testing)
 - External link to [ReaR Automated Testing GitHub Issues](https://github.com/gdha/rear-automated-testing/issues)
 - External link to [Presentation at FroSCon 2017 about ReaR Automated Testing](https://media.ccc.de/v/froscon2017-1957-relax-and-recover_automated_testing)
 - External link to [Relax-and-Recover](http://relax-and-recover.org/)
