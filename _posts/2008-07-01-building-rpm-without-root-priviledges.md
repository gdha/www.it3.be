---
layout: post
title: Howto build a rpm package without root privileges
description: Shows the commands to build a rpm package as plain user
tags: [bash, shell, rpm, rpmbuild, linux, tutorial]
author: gratien
---

In the howto [Howto build an executable from a source rpm](/2008/09/01/howto-build-an-executable-from-a-source-rpm/index.html) we explained how build from a source RPM a binary RPM file as a plain user (non-root). What do we need to get started?

Login in as plain user (this works for all RedHat alike Linux Operating Systems):

    cd $HOME
    mkdir RPM
    cd RPM
    mkdir BUILD RPMS SOURCES SPECS SRPMS

Once the above directories are created you still need to edit the `~/.rpmmacros files` which should contain the following lines:

    %_topdir  ~/RPM
    %__check_files         /usr/lib/rpm/check-files %{buildroot}
    %_unpackaged_files_terminate_build      1
    %_missing_doc_files_terminate_build     1

Thereafter, you can download a source RPM and install it with the rpm command into your local `~/RPM/SOURCES` directory. For example,

    rpm -ivh /tmp/ash-v0.3.8-20.src.rpm

That's it for this howto. See the howto mentioned above for details on how to proceed.
