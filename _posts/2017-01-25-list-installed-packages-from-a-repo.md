---
layout: post
title: List all installed packages from a given YUM repo on Linux
description: Simple procedure to list all installed packages from a certain YUM repo on Linux
tags: [terminal, yum, rpm, Linux, rhel, bash, centos, tutorial, howto, it3 consultants]
author: gratien
---

<strong>List all packages installed from a YUM repo on Linux</strong>

Did you ever wonder if you install a package from which repo it comes? Or, see all packages from a certain repo?

    $ yum repolist 2>/dev/null | awk '/repo id/,/repolist/ {if ($0 !~ "repo id" && $0 !~ "repolist") print $1}'
    RHEL6.8-base
    RHEL6.8-supplementary-x86_64
    RHEL6.8-updates
    epel

Above commands show you the yum repo names which are available on this particular system. To list all packages in
for example `epel` repo we can do the following:

    $ REPO=epel
    $ repoquery --repoid=$REPO -a --qf "%{name}" | sort > /tmp/repo_packages
    $ rpm -qa --qf "%{name}\n" | sort > /tmp/installed_packages
    $ comm -1 -2 /tmp/repo_packages /tmp/installed_packages

What we did above is defining the yum repo we are interested in (in our example `epel`). Then we list up all packages this yum repo `epel` contains in a temporary file (`/tmp/repo_packages`) and list all installed packages on this system in a second file (`/tmp/installed_packages`). Finally, we just list up the packages which currently are present on this Linux system from yum repo `epel`.

We could even create a loop around the output of *repolist* is we wanted.

Enjoy this little feature,
Gratien
