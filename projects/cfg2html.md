---
layout: default
title: Config to HTML (cfg2html) project
description: Project cfg2html sponsored by IT3 Consultants
author: gratien
tags: [cfg2html, open source, korn shell script, HP-UX, SunOS, AIX, Linux, IT3 Consultants, GPL]
---
## Config to HTML (cfg2html) project

[Cfg2html](http://www.cfg2html.com/) is a little utility to collect the necessary system configuration files and system set-up to an ASCII file and HTML file. Simple to use and very helpful in disaster recovery situations.

Collects Linux system configuration into a HTML and text file. Config to HTML is the "swiss army knife" for the sysadmins. It was written to get the necessary informations to plan an update, to perform basic trouble shooting or performance analysis. As a bonus cfg2html creates a nice HTML and plain ASCII documentation from Linux System, Cron and At, installed Hardware, installed Software, Filesystems, Dump- and Swap-configuration, LVM, Network Settings, Kernel, System enhancements and Applications, Subsystems.

Cfg2html works on Linux, HP-UX, SunSO, AIX...

The presentation given at [FOSDEM 2014](https://fosdem.org/2014/schedule/event/cfg2html/) on February 2td 2014 is available, but also the [video that was made by the FOSDEM team](http://ftp.heanet.ie/mirrors/fosdem-video/2014/H2215_Ferrer/Sunday/Linux_Configuration_Collector.webm).

See our [GitHub Source development tree](https://github.com/cfg2html/cfg2html) and clone it to your system via:

    git clone git@github.com:cfg2html/cfg2html.git

A simple output of cfg2html looks like:

    #-> cfg2html
    --=[ http://www.cfg2html.com ]=---------------------------------------------
    Starting          cfg2html-linux version 6.0.1-git201307181324
    Path to Cfg2Html  /usr/sbin/cfg2html
    HTML Output File  /var/log/cfg2html/witsbebelnx02.html
    Text Output File  /var/log/cfg2html/witsbebelnx02.txt
    Partitions        /var/log/cfg2html/witsbebelnx02.partitions.save
    Errors logged to  /var/log/cfg2html/witsbebelnx02.err
    Local config      /etc/cfg2html/local.conf
    Started at        2014-01-14 13:10:36
    WARNING           USE AT YOUR OWN RISK!!! :-))           <<<<<
    --=[ http://www.cfg2html.com ]=---------------------------------------------
    
    Collecting:  Linux System (SUSE Linux Enterprise Desktop 11 (x86_64))  .............................................
    Collecting:  Cron and At  ................
    Collecting:  Hardware  ..........................
    Collecting:  Software  ...............
    Collecting:  Filesystems, Dump- and Swapconfiguration  ..........
    Collecting:  LVM  ............
    Collecting:  Network Settings  ...................................
    Collecting:  Kernel, Modules and Libraries  .....................
    Collecting:  System Enhancements  ...
    Collecting:  Applications and Subsystems  ..............
    
    --=[ http://www.cfg2html.com ]=---------------------------------------------
    Returncode=1 (see /var/log/cfg2html/witsbebelnx02.err)

If you find problems, bugs and have some bright news ideas please make a new [issue](https://github.com/cfg2html/cfg2html/issues) at  our GitHub project pages.


