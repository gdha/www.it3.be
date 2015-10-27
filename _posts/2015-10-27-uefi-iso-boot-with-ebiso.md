---
layout: post
title: UEFI ISO boot with ebiso
description:
tags: [terminal, Linux, rear, SLES, UEFI, EFI, ISO, RHEL, tutorial, howto, it3 consultants]
author: gratien
---

<strong>UEFI ISO boot with ebiso</strong>

UEFI ISO booting is possible with the standard available `mkisofs` or `genisoimage` executable on Debian, Ubuntu and RedHat derivates. 

However, on SuSe SLES or OpenSuSe systems the above mentioned iso creator cannot produce an ISO image which is able to boot on UEFI based systems. The history goes way back to March 2013 - see the discussion of [Rear issue #214](https://github.com/rear/rear/issues/214) for some back ground noice. 

Finally, there is some good news! The project *ebiso* from Vladimir Gozora wrote the missing piece especially for UEFI SLES systems in combination with Relax-and-Recover. The usage of `ebiso` is extremely simple (I like the kiss principle):

    # ebiso -R -o /tmp/bootable.iso -e boot/centos.img /tmp/bootdirfiles

Well, to integrate `ebiso` with [Relax-and-Recover](http://relax-and-recover.org) you need to define in your `/etc/rear/local.conf` or `/etc/rear/site.conf` configuration file the following:

    ISO_MKISOFS_BIN=/usr/bin/ebiso

Be aware, that `ebiso` awareness into rear was introduced after the *rear-1.17.2* release, therefore, use the [development version of rear](http://download.opensuse.org/repositories/Archiving:/Backup:/Rear:/Snapshot/SLE_11_SP3/x86_64/) in case of SLES 11 SP3 or use `git clone git@github.com:rear/rear.git` to download the latest source tree of rear.

Thanks to `ebiso` and `rear` SAP HANA systems running on top of SuSe SLES 11 (or SLES 12) can be recovered - finally! No more legacy boot method needed - Yeah... 

We hope you might find `ebiso` useful!
Gratien

Related links:

* [ebiso wiki](https://github.com/gozora/ebiso/wiki)
* [Source tree of ebiso at GitHub](https://github.com/gozora/ebiso)
* [Gratien fork of ebiso](https://github.com/gdha/ebiso)
* [ebiso RPMs to download for SuSe SLES11/12](http://download.opensuse.org/repositories/home:/gdha/)

