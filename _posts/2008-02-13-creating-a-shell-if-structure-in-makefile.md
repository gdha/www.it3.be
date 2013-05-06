---
layout: post
title: Creating a shell if structure in Makefile
description: Shows how to create an if statement in a Makefile
tags: [bash, terminal, make, Makefile, unix, linux, tutorial]
author: gratien
---
<strong>Did you ever wonder how to make a shell if structure in a Makefile?</strong>

Suppose the following (taken from the Open Source project [Make CD-ROM Recovery](http://mkcdrec.sourceforge.net/)):

If the local configuration file `/etc/mkcdrec.conf` exists then check some local variable first instead of the global configuration file `Config.sh`.

Use the following if construction in the <tt>Makefile</tt> to accomplish this:


    ISOFS_DIR := $(shell if  grep -q ISOFS_DIR= /etc/mkcdrec.conf 2>/dev/null; then \
       grep ISOFS_DIR= /etc/mkcdrec.conf | grep -v ^\# | cut -d= -f 2; \
    else \
       grep ISOFS_DIR= Config.sh | grep -v ^\# | cut -d= -f 2; \
    fi)


The important rule is that all commands should be on one line (or continued with `\`).
