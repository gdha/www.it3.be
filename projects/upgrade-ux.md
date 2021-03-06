---
layout: default
title: Upgrade-UX project
description: The Upgrade-UX Project sponsored by IT3 Consultants
author: gratien
tags: [upgrade-ux, open source, linux, HP-UX, Solaris, AIX, BSD, IT3 Consultants, GPL]
---

##  Upgrade-UX project

<img src="{{ site.url }}/images/upgrade-ux.png" width="51" height="48" border="0" align="left" alt="upgrade-ux logo">

Upgrade-UX (or `upgrade-ux`) is an open source framework developed to assist in patching and/or updating Unix Operating Systems in a consistent and repeatable way. Especially in the industry it is forbidden just to run `yum update` (on Linux) to update your Linux system, therefore, `upgrade-ux` may proof to be a handy tool to guide you through the patching and/or update process as it follows a track you control (evidence gathering, pre/post executing of scripts, logging, and so on).

Upgrade-ux is completely written in Korn Shell which is widely available on all UNIX Operating Systems from Linux, HP-UX, Solaris, AIX, and others. The nice thing about `upgrade-ux` is that the each Operating System follows its own track (via a directory tree structure) so they do not influence each other.

Currently, HP-UX and Linux (for RHEL based Linux distributions) trees are fully populated. People who ever worked with Relax-and-Recover will immediately recognize the internals as it is an exact clone (however, reworked a bit to make it fully Korn Shell aware).

Upgrade-UX has a wide range of features:

 - Simple to use
 - Has a _preview_ mode (to dry-run an upgrade without doing it) and an _upgrade_ mode
 - Is customisable via `local.conf` configuration file
 - Is written in standard Korn Shell (which makes it highly portable)
 - Is UNIX Operating System independent as OS specific tasks reside in their own directory structures
 - Is easy extendable with your own scripts
 - The `upgrade-ux` command leaves a trace in its own log file
 - Running in preview or upgrade mode always creates evidence files
 - Has a man page
 - Has user documentation (you are reading it)
 - Can be used to install patch bundles of previous years with the `YEAR` variable
 - Does understand Serviceguard clusters
 - Can be programmed to bail out on settings you think are too serious to continue
 - Can trigger remote alarms, syslog, monitors,...
 - Can do a basis health check of your system - it is all up to you
 - Has excellent support by its author
 - IT3 Consultants can help you with your internal upgrade projects (need a PO)

The support and development of the Upgrade-UX project takes place
on Github:

 - [Upgrade-UX website]({{ site.url }}/projects/upgrade-ux/)
 - [Github project](http://github.com/gdha/upgrade-ux)
 - [Upgrade-ux User Guide]({{ site.url }}/projects/upgrade-ux/upgrade-ux-user-guide.html)
 - [Lighning-talk FOSDEM 2015](http://mirror.as35701.net/video.fosdem.org/2015/lightning_talks/upgrade_ux.mp4)

In case you have questions, ideas or feedback about this document, you
can contact the development team at: gratien.dhaese at gmail.com.

