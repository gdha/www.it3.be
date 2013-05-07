---
layout: post
title: Howto build an executable from a source rpm
description: Shows the commands to build an executable from a source rpm
tags: [bash, shell, rpm, rpmbuild, linux, tutorial]
author: gratien
---

Sometimes we are unable to find a compiled executable on our particular Linux version. Under these circumstances it is better to download the latest source RPM (for Fedora, RedHat, Centos, SuSe based systems) and to build from the source RPM an executable.

Here we will guide you through this process as a matter of example. Again, we use an example from one of our Open Source project [Make CD-ROM Recovery (mkCDrec)](http://mkcdrec.sourceforge.net) and in more particular ash which is a very small Bourne Shell used in the initial ramdisk of mkCDrec.

We normally use [RPM finder](http://rpmfind.net/) to find the latest source rpm of ash -  in our case it was `ash-0.3.8-20`. We download the rpm and save it in /tmp for example.

A plain user ( non-root ) can unpack the source RPM under his home directory as follow:

    $ cd ~/RPM
    $ rpm -ivh /tmp/ash-0.3.8-20.src.rpm
    1:ash                    ########################################### [100%]
    $ ls SOURCES/
      ash_0.3.8-38.diff.gz  ash-0.3.8-gnu.patch   ash-0.3.8-mannewline.patch
      ash-0.3.8-segv.patch sh-0.3.8-for.patch   ash-0.3.8-history-man.patch
      ash_0.3.8.orig.tar.gz  ash-0.3.8-tempfile.patch
    $ ls SPECS/
      ash.spec  mkcdrec.spec

To build the source RPM we need the rpmbuild executable which is part of rpm-build package.
To check, you can do the following:

    $ rpm -ql rpm-build | head -5
      /usr/bin/rpmbuild
      /usr/lib/rpm/brp-compress
      /usr/lib/rpm/brp-java-gcjcompile
      /usr/lib/rpm/brp-python-bytecompile
      /usr/lib/rpm/brp-redhat

If `rpm-build` package is not available, please install it via yum, up2date, yast or whatever.

Let us compile it now:

    $ cd SPECS
    $ rpmbuild -ba -v ash.spec
    $ ls ../RPMS/i386/
      ash-0.3.8-20.i386.rpm

The newly build binary RPM is saved under the RPMS directory. To install the `ash` executable, just type as user "root":

    # rpm  -i ~/RPM/RPMS/ash-0.3.8-20.i386.rpm


