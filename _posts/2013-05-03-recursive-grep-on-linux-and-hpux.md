---
layout: post
title: Recursive grep on Linux and HP-UX (or any kind of Unix)
description: Shows the commands to find a string recursive on Unix
tags: [bash, shell, unix, linux, grep, find, HP-UX, tutorial]
author: gratien
---

If you are working with source projects or are dealing with lots of text files you sometimes need to find quickly the source or text file containing certain keyword. The easiest command is `grep` with the `-r` option for recursive which is available on Linux, but unfortunately the `-r` option of the `grep` is not available on HP-UX.

As an example we take the [`cfg2html` project](http://www.cfg2html.com) which has it's source tree on [Github](https://github.com/cfg2html/cfg2html)

We found an error with cfg2html on an HP-UX 11.11 system (`exec_command[66]: grepand_grep:  not found`) which we would like to trace back into the sources.

On Linux we could use the `grep` command as follows:

    $ grep -r grepand_grep .
    ./hpux/cfg2html-hpux.sh:    [ -r /etc/my.cnf ] && exec_command "grepand_grep /etc/my.cnf" "MySQL Settings"    #  15.02.2008, 13:30 modified by Ralph Roth

However, on HP-UX the above command returns with an error (`grep: illegal option -- r`), therefore, we need to find another way which comes the closest to the grep command. Any system administrator will say use the `find` command as follows:

    $ find . -type f -exec grep grepand_grep {} \;
    [ -r /etc/my.cnf ] && exec_command "grepand_grep /etc/my.cnf" "MySQL Settings"    #  15.02.2008, 13:30 modified by Ralph Roth

The above output tells us that the cullprit is there, but we still do not know in which file. To fix this do the following:

    $ find . -type f -exec grep grepand_grep {} /dev/null \;
    ./hpux/cfg2html-hpux.sh:    [ -r /etc/my.cnf ] && exec_command "grepand_grep /etc/my.cnf" "MySQL Settings"    #  15.02.2008, 13:30 modified by Ralph Roth

As you can see the last command returns the same output as the `grep -r` command. The last `find` command works also on Linux of course.
