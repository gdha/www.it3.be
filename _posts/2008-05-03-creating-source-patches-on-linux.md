---
layout: post
title: Creating and/or applying source patches on Linux
description: Shows how to create and/or apply a source patch on Linux
tags: [bash, shell, patch, diff, mkcdrec, make, unix, linux, tutorial]
author: gratien
---

On occasion developers send me home-brew patches or whole source bundles, but that takes quite a lot of time to investigate.  However, it is very easy to create a source patch bundle. To be able to create a patch bundle you need 2 source directories of the same product. One with the unmodified (or original) sources and one with your modifications.

Also, make sure before you make the patch that you clean up all unneeded object files and executables (usually via `make clean` or `make distclean`).

To create the patch bundle, which uses the `diff` command, of 2 directories do the following:

    $ diff -Naur  olddir newdir > patch

For example, in case of mkcdrec patch for RHEL5 on ia64 we did the following:

    $ diff - Naur mkcdrec mkcdrec.099-1 > patch-v0.9.9-1-rhel5.ia64

To apply the created patch file on a fresh unpacked source of mkCDrec v0.9.9 just do the following:

    $ cd mkcdrec
    $ patch -p1 < ~/Download/patch-v0.9.9-1-rhel5.ia64
    patching file Config.sh
    Hunk #4 succeeded at 1054 (offset -2 lines).
    patching file etc/fstab
    patching file linuxrc
    patching file linuxrc_find_and_prep_roo
    patching file scripts/Config.sh
    Hunk #4 succeeded at 1058 (offset 2 lines).
    patching file scripts/rd-base.sh
    Hunk #2 succeeded at 3546 (offset 8 lines).

That's it.

