---
layout: post
title: How to convert epoch time to UNIX time format

description: How to convert epoch time to UNIX time format on HP-UX and Linux

tags: [terminal, epoch, time, date, HP-UX, Linux, swverify, it3 consultants]
author: gratien
---

<strong>How to convert epoch time to UNIX time format</strong>

While during a `swverify` command I came across the following error:

    $ swverify PHKL_34161
    ERROR:   File "/opt/fcms/bin/fcmsutil" should have mtime "1138964905"
             but the actual mtime is "1400486913".

Nice error, but that does not tell me which date format to use with the command `touch`, as

    $ touch -m -t 1138964905 /opt/fcms/bin/fcmsutil
    date: bad conversion

Found a few methods that produced the output I was looking for on:

    HP-UX: $ echo 0d1138964905=Y | adb
           2006 Feb  3 12:08:25

    HP-UX/Linux: $ perl -le 'print scalar localtime(1138964905)'
                 Fri Feb  3 12:08:25 2006

    Linux: $ echo 1138964905 | awk '
           {printf("%s", strftime("%Y.%m.%d ",$1));
           printf("%s", strftime("%H:%M:%S \n",$1));
           }'
           2006.02.03 12:08:25

Ok, we have now the date - using `touch` to modify the date:

     $ touch -m -t 200602031208.25 /opt/fcms/bin/fcmsutil
     $ swverify PHKL_34161

The `swverify` command is now very happy with the correct date.

External Links:
* [General description on Unix/Epoch time](http://en.wikipedia.org/wiki/Unix_epoch)
* [Several date commands and script goodies](http://www.unix.com/answers-to-frequently-asked-questions/13785-yesterdays-date-date-arithmetic.html)

