---
layout: post
title: Creating a yum repository (kind of patch bundle)
description:
tags: [terminal, Linux, Fedora, CentOS, RHEL, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Creating a yum repository (kind of patch bundle)</strong>

We will guide you through the process of building up your own yum repository (or patch bundle) for CentOS 7. For RHEL and Fedora it is exactly the same process.

A virtual machine with a base system setup is a nice starting point to create a delta yum repo. You can create many repositories until you are pleased with the result. Once you apply the repo you can start with a new one. However, it is the purpose that the repo (or patch bundle) can be rolled out to many similar systems within your company.

Before kicking off it is always wise to test the RPM database integrity with the command:

    $ yum check  # to verify yum rpmdb integrity
    Loaded plugins: fastestmirror, langpacks
    check all
    $ echo $?
    0

To list the current list of repositories you can use the command:

    $ yum repolist
    Loaded plugins: fastestmirror, langpacks
    Loading mirror speeds from cached hostfile
     * base: mirror.bytemark.co.uk
     * extras: mirror.bytemark.co.uk
     * updates: mirror.bytemark.co.uk
    repo id                                                       repo name                                                        status
    base/7/x86_64                                                 CentOS-7 - Base                                                  8,465
    extras/7/x86_64                                               CentOS-7 - Extras                                                  102
    updates/7/x86_64                                              CentOS-7 - Updates                                               1,550
    repolist: 10,117

With the command `yum check-update` you can see all the available updates in above mentioned repositories, but what we want is create our own selection of updates and fixes. We want to be controlling what is happening on our systems, right?


Before you start downloaded the RPMs first create a directory for your own repo:

    $ sudo mkdir -m 755 /var/html/repo-jan-2015

Now you can download the RPMs into this newly created directory (we will *not* install the RPMs):

    $ sudo yum update --downloadonly --downloaddir=/var/html/repo-jan-2015
    ...
    (145/146): selinux-policy-targeted-3.12.1-153.el7_0.13.noarch.rpm                                                    | 3.8 MB  00:00:01
    (146/146): kernel-3.10.0-123.13.2.el7.x86_64.rpm                                                                     |  29 MB  00:00:14
    Finishing delta rebuilds of 84 package(s) (87 M)
    --------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                       996 kB/s |  96 MB  00:01:38
    exiting because "Download Only" specified
    
To create a repo we need a tool called `createrepo`. If it is not present install it via the command:

    $ sudo yum install createrepo

Now, we can actually create a repo, e.g. repo-jan-2015

    $ sudo createrepo /var/html/repo-jan-2015

We have a directory ready now with all the RPMs including the repo XML definitions which were created by `createrepo`. We still need to define a yum repo configuration file, e.g. `/etc/yum.repos.d/CentOS-Updates-Jan-2015.repo`

    $ sudo vi /etc/yum.repos.d/CentOS-Updates-Jan-2015.repo
    [Updates-Jan-2015]
    name=CentOS $releasever - $basearch - Released Updates Jan 2015
    baseurl=http://127.0.0.1:80/var/html/repo-jan-2015/
    #baseurl=http://localhost/var/html/repo-jan-2015/
    enabled=1     # make it 0 when no local httpd is running
    gpgcheck=1

As we defined `enabled=1` then we must run a small HTTP server locally to test against. Found a little Python tool on the internet (see related links) called `httpserve.py`. To start it do the following (the `cd /` is important, otherwise baseurl will not be found):

    # cd / ; /tmp/httpserve.py 80 &
    serving at port 80

To be able to test it locally we should instruct our firewall to open communication on these ports (80 and 8000):

    $ sudo firewall-cmd --add-port=8000/tcp
    $ sudo firewall-cmd --add-service=http
    $ sudo firewall-cmd --add-source=127.0.0.1
    $ sudo firewall-cmd --list-all

At this point your new created repo *Updates-Jan-2015* should be available for local usage:

    $ sudo yum repolist
    Loaded plugins: fastestmirror, langpacks
    Updates-Jan-2015                                                                                              | 2.9 kB  00:00:00
    Updates-Jan-2015/primary_db                                                                                   | 466 kB  00:00:00
    Loading mirror speeds from cached hostfile
     * base: mirror.bytemark.co.uk
     * extras: mirror.bytemark.co.uk
     * updates: mirror.bytemark.co.uk
    repo id                                          repo name                                                                     status
    Updates-Jan-2015                                 CentOS 7 - x86_64 - Released Updates Jan 2015                                   146
    base/7/x86_64                                    CentOS-7 - Base                                                               8,465
    extras/7/x86_64                                  CentOS-7 - Extras                                                               103
    updates/7/x86_64                                 CentOS-7 - Updates                                                            1,568
    repolist: 10,282
    
You can list the content of the repo as following:

    $ sudo yum repository-packages Updates-Jan-2015 list
    Loaded plugins: fastestmirror, langpacks
    Loading mirror speeds from cached hostfile
     * base: mirror.bytemark.co.uk
     * extras: mirror.bytemark.co.uk
     * updates: mirror.bytemark.co.uk
    Available Packages
    NetworkManager.x86_64                                   1:0.9.9.1-29.git20140326.4dba720.el7_0                       Updates-Jan-2015
    NetworkManager-glib.x86_64                              1:0.9.9.1-29.git20140326.4dba720.el7_0                       Updates-Jan-2015
    ....


To perform a test installation (without really doing it, aka preview) use the command:

    $ sudo yum  --assumeno  repository-packages Updates-Jan-2015 install


This was a high level explanation of how you can create your own repositories, however, fine-tuning and testing it out is very important and time consuming. You may not under estimate this.

A small word of advise: before applying patch bundles (or doing updates) make a disaster recover snapshot with your tool of preference, e.g. relax-and-recover (rear).

Related links:
* [Create a Local Yum Repository](http://dotancohen.com/howto/yum_repo.html)
* [Source of httpserve.py](https://gist.github.com/ThomasChiroux/3786940)
* [Relax-and-Recover (rear)](http://relax-and-recover.org/)
