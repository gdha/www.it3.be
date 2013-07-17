---
layout: post
title: Adding missing fedora release branch to build environment
description: 
tags: [bash, terminal, linux, fedora, git, tutorial, it3 consultants]
author: gratien
---
<strong>Every time Fedora has a new release (twice a year) we need to build our Open Source packages for this. Over and over again I forget the basic steps.</strong>

For example to build [rear](http://relax-and-recover.org) for Fedora 19 I need a branch for it in Fedora's git environment. Basically, I had the following:

    $ fedpkg switch-branch -l
    Locals:
      el4
      el5
      el6
      f12
      f13
      f14
      f15
      f17
    * f18
      master
    Remotes:
      origin/el4
      origin/el5
      origin/el6
      origin/f10
      origin/f11
      origin/f12
      origin/f13
      origin/f14
      origin/f15
      origin/f16
      origin/f17
      origin/f18
      origin/master

As you can see in the above example Fedora 19 (f19) is missing in the list. Before requesting the missing branch in Bugzilla's ticket of your initial software request check if it is not already available with the command:

    $ git pull
    Enter passphrase for key '~/.ssh/id_rsa_fedora':
    From ssh://pkgs.fedoraproject.org/rear
     * [new branch]      f19        -> origin/f19
    Already up-to-date.

There it is (no need to request this branch via RedHat Bugzilla). Finally we can switch to the f19 release branch:

    $ fedpkg switch-branch f19
    Branch f19 set up to track remote branch f19 from origin.

