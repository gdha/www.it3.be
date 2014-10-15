---
layout: post
title: What to do when no events arrive at the HP SIM console
description:
tags: [terminal, hpux, HP-UX, HP SIM, tutorial, howto, it3 consultants]
author: gratien
---

<strong>HP-UX 11.31 systems are not sending events to HP SIM console and on first glance all seems fine - what now?</strong>

Assuming you did already lots of checks and all seems fine with HPSIM and HPWEBES subscriptions? No clue what we are talking about? Resume a little bit. HP-UX 11.31 systems can be added to HP SIM console to have their hardware monitored and automatic tickets can be generated when an hardware issue is found. However, before a HP-UX systems can be monitored correctly via HP SIM a lot of additional software must be installed and configured. That alone is a huge challenge to get it right. For that part we wrote an Open Source tool called *WBEMextras* that will take care of installing and configuring the software.

Part of WBEMextras is a script called `HPSIM-HealthCheck.sh` that verifies if the basics are correctly configured on the HP-UX system where you run the script. Now, you did all this and still no events arrive at the HP SIM console? Ok, try the following:

    grep "^$(date '+%m/%d/%y')" /var/opt/sfm/log/sfm.log | grep -e ERROR -e CRITICAL

If you see error lines like shown below:

    10/13/14 13:21:36 commonLog 120 ERROR 14505 16 DB Connection failed to LOGDB...
    10/13/14 20:21:35 commonLog 229 CRITICAL 490 11 Error while updating database. Unable to connect to database LOGDB.
    10/14/14 02:21:35 commonLog 231 CRITICAL 24430 11 Error connecting to Common Log database.

Then, your postgress database is not working anymore. Why? Not very clear, but most likely after an upgrade of the System Fault Management software the database got corrupted. To get this fixed (as nothing is recorded anyway, nor send to HP SIM) do the following steps:

    swconfig -u SysFaultMgmt
    swconfig SysFaultMgmt
    /sbin/init.d/hpsmh start

You can now send a test event to HP SIM console via the command:

    sfmconfig -t -a

Also, check the `/var/opt/sfm/log/sfm.log` log file again; the errors should not be seen anymore. Now login on the HP SIM console and check under the events tab of this system to see if some test events arrived (of type 4).

Related links:
* [WBEMextras home page](http://wbemextras.github.io/)
* [WBEMextras GitHub source](https://github.com/WBEMextras/WBEMextras)

