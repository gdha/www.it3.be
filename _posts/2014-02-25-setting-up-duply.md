---
layout: post
title: Setting up duply

description: How-to install and setup duply (using duplicity)

tags: [terminal, cryptography, GnuPG, gpg, duply, duplicity, howto, it3 consultants]
author: gratien
---

<strong>How to install and setup duply (using duplicity)</strong>

Making a secure (encrypted) backup to a cloud storage provider sounds very complicated to realize, but as a matter of fact using duply (with duplicity) it is not that difficult at all.

First of all, you need to install and [generate GnuPG cryptographic keys](/2014/02/14/gnupg-key-generation/).

Installing duply and duplicity you can do the following (on Centos/Fedora/RHEL):

    # yum install duplicity
    Dependencies Resolved
    
    =======================================================================================
     Package                     Arch             Version            Repository      Size
    =======================================================================================
    Installing:
     duplicity                   x86_64        0.6.22-5.fc20         updates         511 k
    Installing for dependencies:
     librsync                    x86_64        0.9.7-21.fc20         fedora           47 k
     ncftp                       x86_64        2:3.2.5-6.fc20        fedora          340 k
     python-GnuPGInterface       noarch        0.3.2-12.fc20         fedora           26 k
     python-boto                 noarch        2.13.3-1.fc20         fedora          1.4 M
     python-crypto               x86_64        2.6.1-1.fc20          fedora          470 k
     python-dropbox              noarch        1.6-4.fc20            fedora           61 k
     python-paramiko             noarch        1.10.1-2.fc20         fedora          655 k
    
    Transaction Summary
    =======================================================================================
    Install  1 Package (+8 Dependent packages)
    
    # yum install duply
    Dependencies Resolved
    
    =======================================================================================
     Package                      Arch            Version            Repository      Size
    =======================================================================================
    Installing:
     duply                        noarch       1.5.11-2.fc20         fedora           38 k
    
    Transaction Summary
    =======================================================================================
    Install  1 Package
    
On Ubuntu you need to install:

     # apt-get install duply
     # apt-get install python-paramiko
     

Now that we have the necessary software installed we can create an empty profile (e.g. *mycloud*) using the following command:

    $ duply ~/.duply/mycloud create

This creates a template profile that you still need to edit and configure according your needs. Edit it:

    $ vi ~/.duply/mycloud/conf

You need to uncomment and add your key-id into the variable `GPG_KEY` and the same for your *secret* passhrase (into variable `GPG_PW`). You also need to define the `SOURCE` (from which you want a backup) and `TARGET` directory path (where you store the backup).

The `GPG_KEY` can easily be found with the command `gpg --list-keys`.

To define the `TARGET` variable you need to follow a certain syntax (the profile file *mycloud/conf* explains it well).

To test the remote connection, and the very first time you will be prompted to accept the remote destination:

    $ duply mycloud status
    Start duply v1.5.11, time is 2014-02-06 10:57:58.
    Using profile '/home/gdha/.duply/mycloud'.
    Using installed duplicity version 0.6.22, python 2.7.5, gpg 1.4.16 (Home: ~/.gnupg), awk 'GNU Awk 4.1.0, API: 1.0', bash '4.2.45(1)-release (x86_64-redhat-linux-gnu)'.
    Autoset found secret key of first GPG_KEY entry '72624EFE' for signing.
    Test - Encrypt to 72624EFE & Sign with 72624EFE (OK)
    Test - Decrypt (OK)
    Test - Compare (OK)
    Cleanup - Delete '/tmp/duply.2373.1391680678_*'(OK)
    Export PUB key 72624EFE (OK)
    Write file 'gpgkey.72624EFE.pub.asc' (OK)
    Export SEC key 72624EFE (OK)
    Write file 'gpgkey.72624EFE.sec.asc' (OK)
    
    INFO:
    
    duply exported new keys to your profile.
    You should backup your changed profile folder now and store it in a safe place.
    
    --- Start running command STATUS at 10:57:59.145 ---
    Using archive dir: /home/gdha/.cache/duplicity/duply_mycloud
    Using backup name: duply_mycloud
    Import of duplicity.backends.swiftbackend Succeeded
    Import of duplicity.backends.u1backend Succeeded
    Import of duplicity.backends.webdavbackend Succeeded
    Import of duplicity.backends.rsyncbackend Succeeded
    Import of duplicity.backends.dpbxbackend Failed: No module named pkg_resources
    Import of duplicity.backends.megabackend Succeeded
    Import of duplicity.backends.gdocsbackend Succeeded
    Import of duplicity.backends.hsibackend Succeeded
    Import of duplicity.backends.cloudfilesbackend Succeeded
    Import of duplicity.backends.imapbackend Succeeded
    Import of duplicity.backends.ftpbackend Succeeded
    Import of duplicity.backends.botobackend Succeeded
    Import of duplicity.backends.sshbackend Succeeded
    Import of duplicity.backends.tahoebackend Succeeded
    Import of duplicity.backends.localbackend Succeeded
    Import of duplicity.backends.ftpsbackend Succeeded
    The authenticity of host '[mycloudserver.net]:6677' can't be established.
    SSH-RSA key fingerprint is 78:b3:13:5a:54:a9:71:89:a0:a5:d2:14:b6:94:57:e4.
    Are you sure you want to continue connecting (yes/no)? yes
    Main action: collection-status
    ================================================================================
    duplicity 0.6.22 (August 22, 2013)
    Args: /usr/bin/duplicity collection-status --name duply_mycloud --encrypt-key 72624EFE --sign-key 72624EFE --verbosity 5 --ssh-askpass ssh://gdha@mycloudserver.net:6677//media/mycloud/gdha_backup
    Linux fedora20 3.12.8-300.fc20.x86_64 #1 SMP Thu Jan 16 01:07:50 UTC 2014 x86_64 x86_64
    /usr/bin/python 2.7.5 (default, Nov 12 2013, 16:45:54)
    [GCC 4.8.2 20131017 (Red Hat 4.8.2-1)]
    ================================================================================
    Local and Remote metadata are synchronized, no sync needed.
    Last full backup date: none
    Collection Status
    ---
    Connecting with backend: SSHParamikoBackend
    Archive dir: /home/gdha/.cache/duplicity/duply_mycloud
    
    Found 0 secondary backup chains.
    No backup chains with active signatures found
    No orphaned or incomplete backup sets found.
    Using temporary directory /tmp/duplicity-4tjVPe-tempdir
    --- Finished state OK at 10:58:06.108 - Runtime 00:00:06.963 ---
    


If above test was successful you can now backup to a remote (cloud storage based) server, with the command:

    $ duply mycloud backup

There might be one interesting item to mention is the *exclude* file list if you want to make a full backup. `duplicity` will hang if we do not exclude the file systems `/proc` and `/sys`. To avoid this just add these two file systems to the file `~/.duply/<profile>/exclude`

*Last Update: 26 August 2015 (added some minor clarifications and the Ubuntu install part)*
