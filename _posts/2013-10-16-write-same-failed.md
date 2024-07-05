---
layout: post
title: How to get rid of WRITE SAME failed?

description: In syslog we see messages like WRITE SAME failed. Manually zeroing.

tags: [terminal, linux, systemd, tutorial, howto, it3 consultants]
author: gratien
---

<strong>How to get rid of the message "WRITE SAME failed. Manually zeroing."?</strong>

On my fedora system running kernel 3.11.4-201.fc19.x86_64 we see lots of messages in the syslog file like:

    kernel: dm-1: WRITE SAME failed. Manually zeroing.

This has to do with SMART capabilities as we can see with the command:

    $ sudo smartctl -i /dev/sda | grep SMART
    SMART support is:     Unavailable - device lacks SMART capability.

Fine, how can we disable it then? Execute the following set of commands:

    $ find /sys | grep max_write_same_blocks
    /sys/devices/pci0000:00/0000:00:10.0/host2/target2:0:0/2:0:0:0/scsi_disk/2:0:0:0/max_write_same_block

Now, add this device into a new tmpfile configuration file (which will be picked up by systemd). For details check tmpfiles.d(5).
Create a file (must ending with ".conf") in `/etc/tmpfiles.d/`:

    $ sudo cat > /etc/tmpfiles.d/write_same.conf <<EOD
    # Type Path        Mode UID  GID  Age Argument
    w /sys/devices/pci0000:00/0000:00:10.0/host2/target2:0:0/2:0:0:0/scsi_disk/2:0:0:0/max_write_same_blocks  -   -   -   -  0
    EOD

The next time your computer restart the message should go away. Keep fingers crossed.
