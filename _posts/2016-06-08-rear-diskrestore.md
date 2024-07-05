---
layout: post
title: Rear diskrestore script
description:
tags: [terminal, rear, relax-and-recover, Linux, script, bash, support, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Relax-and-recover (rear) diksrestore script</strong>

Best kept secret of recovering with rear is the creation of the `diskrestore.sh` on the fly with the input from
`/var/lib/rear/layout/disklayout.conf` file. On occasion issues are created with questions related of failing
to recreate a disk layout (via cloning) and then the `disklayout.conf` is posted. We are always puzzled to
recreate the `diskrestore.sh` script by hand (or at least pieces of it).

Therefore, we thought it would be nice if we wrote a script which re-creates the `diskrestore.sh` script as we
were busy with doing a *`rear recover`* without destroying our disks of course. It is always nice to see what
rear makes of the given `disklayout.conf` input and see what the corresponding output is (`diskrestore.sh`).
That way it makes it easier to understand what might be the issue.

The script `make_rear_diskrestore_script.sh` can be download from the *mismas* github project of Gratien and does
not require any arguments (yet).

    $  ~/projects/mismas/make_rear_diskrestore_script.sh 
    ERROR: make_rear_diskrestore_script.sh needs ROOT privileges!
    $ sudo  ~/projects/mismas/make_rear_diskrestore_script.sh 
    
    ##################################################################################
    #       Starting make_rear_diskrestore_script.sh to produce layout code script
    #       (for debugging purposes only)
    #
    #       Log file : /var/log/rear/make_rear_diskrestore_script-20160608-0943.log
    #       date : Wed Jun  8 09:43:58 CEST 2016
    ##################################################################################
    
    
    
    You can now check the script /var/lib/rear/layout/diskrestore.sh
    Do _not_ execute script /var/lib/rear/layout/diskrestore.sh
    
As you can see from the example above just run the script `make_rear_diskrestore_script.sh` and let it run. Please note, that the script requires root privileges and of course the input file `/var/lib/rear/layout/disklayout.conf`. It will complain it not found and explain what needs to be done (running `rear savelayout`).

The output script (`diskrestore.sh`) can be reviewed for in-depth analysis by the user, e.g.:

    $ sudo ls /var/lib/rear/layout/
    config	       disklayout.conf			   disklayout.conf.20160608.2703.bak  diskrestore.sh.20160608.2703.bak	lvm
    diskdeps.conf  disklayout.conf.20160607.22087.bak  diskrestore.sh		      disktodo.conf

You will notice that the `make_rear_diskrestore_script.sh` makes use of rear libraries and similates a part of the *recover* process, that is the reason you see in the `/var/lib/rear/layout/` directory the backup files. These may be removed afterwards, including the diskrestore.sh script itself as it will always be recreated by `rear` itself during a real recovery.


    #!/bin/bash
    # Script /home/gdha/projects/mismas/make_rear_diskrestore_script.sh produced this /var/lib/rear/layout/diskrestore.sh file
    # It is meant as debugging aid - do not run it or edit it
    # Gratien D'haese - gratien . dhaese @ gmail . com
    # Copyright GPLv3
    #
    ############################################################
    #
    echo "Script /home/gdha/projects/mismas/make_rear_diskrestore_script.sh produced /var/lib/rear/layout/diskrestore.sh file"
    echo "It is not meant to be executed - just to review the code"
    echo "which recreates your disk layout (for debugging reasons)"
    echo
    echo "Force exit..."
    exit 1
    ############################################################
    ############################################################
    # Script /var/lib/rear/layout/diskrestore.sh starts below
    ############################################################
    ############################################################
    #!/bin/bash
    
    LogPrint "Start system layout restoration."
    
    mkdir -p /mnt/local
    if create_component "vgchange" "rear" ; then
        lvm vgchange -a n >&8
        component_created "vgchange" "rear"
    fi
    
Above you see only a small part of a real example of the output and as you can see I protected you from accidental
running the script as root and wiping out your disk.

The output is meant for debugging purposes only (so you can see what a recover would execute to recreate your boot disk layout). Or, in case you are completely lost you can [open an issue](https://github.com/rear/rear/issues).
But, if you expect an answer (on the diskrestore output) a [rear subscription, rear support contract or donation is required](http://relax-and-recover.org/support/sponsors).

Happy coding - Gratien

References:

* [Source of make_rear_diskrestore_script.sh](https://github.com/gdha/mismas/blob/master/make_rear_diskrestore_script.sh)
* [mismas script collection](https://github.com/gdha/mismas)
* [Relax-and-Recover](http://relax-and-recover.org/)
* [Relax-and-Recover Issues](https://github.com/rear/rear/issues)
* [Relax-and-Recover Sponsoring](http://relax-and-recover.org/support/sponsors)
