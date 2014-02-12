---
layout: post
title: Mounting an ISO image on HP-UX 11.31

description: How-to mount an ISO image on HP-UX 11.31

tags: [terminal, HP-UX, ISO, howto, it3 consultants]
author: gratien
---

<strong>How to mount an ISO image on HP-UX 11.31</strong>

The easiest way to mount an ISO image as a normal file system on HP-UX 11.31 is by having *cdfs ISO image mount support* on the Operating System level. Therefore, install the free product ISOIMAGE-ENH (ISO Image mount Enhancement). The latest version of [ISOIMAGE-ENH](https://h20392.www2.hp.com/portal/swdepot/displayProductInfo.do?productNumber=ISOIMAGE-ENH) is available for free at the HP software download site.

Because this product is delivered as a Dynamically Loadable Kernel Module (DLKM) named fspd, use the following commands to load and unload the fspd module after installing the depot: 

- To load:

    # kcmodule fspd=loaded

- To unload:

    # kcmodule fspd=unused


Mounting an ISO image is then pretty easy:

    # mount -F cdfs /media/iso/raidmgr_01-30-03-t1610--10057.iso  /tmp2
    # bdf /tmp2
    Filesystem          kbytes    used   avail %used Mounted on
    /dev/fspd1          285154  285154       0  100% /tmp2
    # mount | grep /tmp2
    /tmp2 on /dev/fspd1 ro,rr,dev=6000001 on Wed Feb  5 03:30:25 2014


