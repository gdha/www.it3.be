---
layout: post
title: NETFS compression tests
description: 
tags: [bash, terminal, linux, rear, Relax-and-Recover, Relax and Recover, tutorial, it3 consultants]
author: gratien
---
<strong>Compression tests performed with Relax and Recover (rear) with the BACKUP=NETFS workflow</strong>

The default values defined in `/usr/share/rear/conf/default.conf` are the following:

    BACKUP_PROG=tar
    BACKUP_PROG_SUFFIX=".tar"
    BACKUP_PROG_COMPRESS_OPTIONS="--gzip"
    BACKUP_PROG_COMPRESS_SUFFIX=".gz"

However, we can easily overrule these setting in the `/etc/rear/local.conf` file. To use `bzip2` define the following variables in the `local.conf` file:

    BACKUP_PROG_COMPRESS_OPTIONS="--bzip2"
    BACKUP_PROG_COMPRESS_SUFFIX=".bz2"

Another compression method is `xz`:

    BACKUP_PROG_COMPRESS_OPTIONS="--xz"
    BACKUP_PROG_COMPRESS_SUFFIX=".xz"

We have performed some compression tests with rear:
<img src="{{ site.url }}/images/netfs-compression-comparison.png" border="0" align="left" alt="Rear compression test" />

We may conclude that the generic compression method selected (`gzip`) is a good choice.
