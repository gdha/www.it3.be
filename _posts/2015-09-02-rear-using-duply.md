---
layout: post
title: Rear using duply as backup method

description: Rear using duply as backup method

tags: [terminal, cryptography, GnuPG, gpg, duply, duplicity,rear, relax-and-recover, howto, it3 consultants]
author: gratien
---

<strong>Rear using duply as backup method</strong>

In previous blog posts we described how to make a [secure (encrypted) backup to a cloud storage provider using duply (with duplicity)](/2014/02/25/setting-up-duply/) and how to [generate GnuPG cryptographic keys](/2014/02/14/gnupg-key-generation/).

We can use duply (or duplicity) with [relax-and-recover (rear)]({ site.url }/projects/rear.html) to take care of full backup of the GNU/Linux system. Therefore, duplicity is responsible for backup and restore and rear is just taking care of the rescue image and doing the restore of the disk partitions, including creating volume groups and file systems. After that, rear hands over the task to duplicity to do the restore. And, finally, when all has been restored (read the OS part) take care of making the disk bootable using grub or another boot loader.

The way duply works we first have to setup a duply profile as user root, which defines the backup/restore path towards the cloud infrastructure, e.g.

    # grep -v \# /root/.duply/ubuntu-15-04-backup/conf | sed -e '/^$/d'
    GPG_KEY='BD4A8DCC'
    GPG_PW='my_secret_key_phrase'
    TARGET='scp://root:my_secret_password@freedom//exports/archives/ubuntu-15-04'
    SOURCE='/'
    MAX_AGE=1M
    MAX_FULL_BACKUPS=1
    MAX_FULLS_WITH_INCRS=1
    VERBOSITY=5
    TEMP_DIR=/tmp
    
What does the above configuration accomplishes? Well, it comes to a full backup of `/` being send to a remote system *freedom* using encrypted duplicity backup method. However, we must avoid making backups of some directories to avoid hangs during the restore. We do that by adding these in the `exclude` file listed as one file system per line:

    # grep -v \# /root/.duply/ubuntu-15-04-backup/exclude | sed -e '/^$/d'
    /proc
    /sys
    /run
    /var/lib/ntp/proc
    /root/.cache
    /tmp
    /var/tmp
    /mnt
    
Now we think we have a working duplicity backup, right? Wrong, you better check it by using the command:

    # duply ubuntu-15-04-backup status
    Start duply v1.9.1, time is 2015-09-02 15:19:49.
    Using profile '/root/.duply/ubuntu-15-04-backup'.
    ...
    Found primary backup chain with matching signature chain:
    -------------------------
    Chain start time: Wed Aug 26 11:06:44 2015
    Chain end time: Thu Aug 27 11:03:32 2015
    Number of contained backup sets: 3
    Total number of contained volumes: 45
     Type of backup set:                            Time:      Num volumes:
                    Full         Wed Aug 26 11:06:44 2015                35
             Incremental         Thu Aug 27 10:58:24 2015                 5
             Incremental         Thu Aug 27 11:03:32 2015                 5
    -------------------------
    No orphaned or incomplete backup sets found.
    Using temporary directory /tmp/duplicity-X4ETex-tempdir
    --- Finished state OK at 15:19:50.907 - Runtime 00:00:00.891 ---
    
So it seems we have a working duply setup. We can now configure relax-and-recover (rear) if it is installed of course. If not, you can [download it from the web](http://relax-and-recover.org/download/) 
The configuration we need to setup up so that rear works with duplicity (and duply) is as follow:

    # grep -v \# /etc/rear/site.conf | sed -e '/^$/d'
    BACKUP=DUPLICITY
    DUPLY_PROFILE="ubuntu-15-04-backup"
    OUTPUT=ISO
    OUTPUT_URL=nfs://freedom/exports/isos
    
The `site.conf` file is telling rear to use the backup method duplicity with the variable `BACKUP=DUPLICITY` and as we want to use `duply` wrapper we need to tell rear to use the corresponding profile with the variable `DUPLY_PROFILE`. On the other hand, we define to send the rescue image as an ISO image (via `OUTPUT=ISO`) to a remote nfs server (*freedom*) via the definition of `OUTPUT_URL=nfs://freedom/exports/isos`

To create a rear rescue image we can type `rear -v mkrescue` and that should be it as far what rear concerns as the customer is responsible to foresee a full backup of the system. Normally, as duplicity is an external backup method for relax-and-recover, rear is not making any backup at all. However, somebody made a pull request which does make a full backup using duplicity during a rear session. Therefore, if you use `rear -v mkbackup` it will create a rescue image and start making a backup as well.

    # rear -v mkbackup
    Relax-and-Recover 1.17.1 / Git
    Using log file: /var/log/rear/rear-ubuntu-15-04.log
    The last full backup taken with duply/duplicity was:
    Last full backup date: Wed Aug 26 11:06:44 2015
    Creating disk layout
    Creating root filesystem layout
    TIP: To login as root via ssh you need to set up /root/.ssh/authorized_keys or SSH_ROOT_PASSWORD in your configuration file
    Copying files and directories
    Copying binaries and libraries
    Copying kernel modules
    Creating initramfs
    Making ISO image
    Wrote ISO image: /var/lib/rear/output/rear-ubuntu-15-04.iso (132M)
    Copying resulting files to nfs location
    Starting full backup with duply/duplicity

To verify that a backup was created you could re-run `duply ubuntu-15-04-backup status` and you should see at the end:

         Type of backup set:                            Time:      Num volumes:
                    Full         Wed Aug 26 11:06:44 2015                35
             Incremental         Thu Aug 27 10:58:24 2015                 5
             Incremental         Thu Aug 27 11:03:32 2015                 5
             Incremental         Wed Sep  2 16:05:41 2015                 5
    -------------------------
    No orphaned or incomplete backup sets found.
    Using temporary directory /tmp/duplicity-dzm3hQ-tempdir
    --- Finished state OK at 16:07:48.580 - Runtime 00:00:00.672 ---
    
To recover this system afterwards you just need to boot from the rescue image created and type `rear -v recover` to restore the complete system using rear and duplicity.

