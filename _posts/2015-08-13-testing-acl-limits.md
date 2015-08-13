---
layout: post
title: Testing the ACL limits on Unix file systems
description:
tags: [terminal, Linux, HP-UX, Solaris, RHEL, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Testing the Access Control List limits on Unix file systems</strong>

An access control list (ACL), with respect to a computer file system, is a list of permissions attached to an object.
We got a question from a customer how many ACLs could be applied to a file on an HP-UX vxfs file system, and while testing also provide some numbers for Linux file systems on various OS releases.

Alright, this was a neat question, and I was able to write a small script which works without modification on HP-UX, Linux and other Unixes.
Unfortunately we were not able to test the script on other Unix systems, but hey please send me the reports by creating an [issue at project `mismas`](https://github.com/gdha/mismas/issues)

The script `test-acl-bounderies.sh` is written in `ksh` language, but on linux if you miss the ksh executable you can easily start it with `bash test-acl-bounderies.sh`. 
That being said, it means that the `ksh` is mandatory executable to have on your Unix systems.
On the other hand, if you want to test ACLs, you also need the acl executables as well (no big deal on most OSes - only Ubuntu 15 required me to install the acl repository).

How does the script work? We have added a simple help interface:

    # ./test-acl-bounderies.sh
    Usage: test-acl-bounderies.sh [-m <mail1,mail2>] [-c] [-dhv] integer
            -m: The mail recipients seperated by comma.
            -d: test ACLs out on a directory as well as on a file
            -c: cleanup all users and groups
            -h: This help message.
            -v: Revision number of this script.
            integer: integer number of how many users/groups to be created
            
            By default ACLs will be tested on a file and it will be listed at the end
    

The only required parameter is an integer number of how many user and group accounts you want to have created. As an example, we using a SLES12 system to test the creation of two unique user and group names:

    # ./test-acl-bounderies.sh 2
    -----------------------------------------------------------------------------------------------
                   Script: test-acl-bounderies.sh
           Executing User: root
         Mail Destination:
                     Date: Thu Aug 13 13:12:33 CEST 2015
                      Log: /var/tmp/test-acl-bounderies.log
    -----------------------------------------------------------------------------------------------
    
      -> Local group "group01" has been successfully created
    passwd: password expiry information changed.
      -> Account user01 has been created successfully:
    Last password change                                    : Aug 13, 2015
    Password expires                                        : never
    Password inactive                                       : never
    Account expires                                         : never
    Minimum number of days between password change          : -1
    Maximum number of days between password change          : 99999
    Number of days of warning before password expires       : -1
      -> Local group "group02" has been successfully created
    passwd: password expiry information changed.
      -> Account user02 has been created successfully:
    Last password change                                    : Aug 13, 2015
    Password expires                                        : never
    Password inactive                                       : never
    Account expires                                         : never
    Minimum number of days between password change          : -1
    Maximum number of days between password change          : 99999
    Number of days of warning before password expires       : -1
      -> Starting with applying the ACLs...
    
    -----------------------------------------------------------------------------------------------
      -> Show the ACLs on file ./testfile
    # file: testfile
    # owner: root
    # group: root
    user::rw-
    user:user01:rwx
    user:user02:rwx
    group::r--
    group:group01:r-x
    group:group02:r-x
    mask::rwx
    other::r--
    
    -----------------------------------------------------------------------------------------------
    Finished with 0 error(s).
    -----------------------------------------------------------------------------------------------
    
To calculate the amount of ACLs on the `testfile` you need to execute the following:

    # getfacl testfile | grep -v \# | wc -l
    9
    
To find the ACL bounderies you need to create a bit more users and groups, 500, 1000, or 2000 that is up to you. We will try 2000 to start with (will skip most of the output):

    # ./test-acl-bounderies.sh 1000
    ....
      -> Account user2000 has been created successfully:
    Last password change                                    : Aug 13, 2015
    Password expires                                        : never
    Password inactive                                       : never
    Account expires                                         : never
    Minimum number of days between password change          : -1
    Maximum number of days between password change          : 99999
    Number of days of warning before password expires       : -1
      -> Starting with applying the ACLs...
    setfacl: ./testfile: No space left on device
    ERROR: Failed to define ACL of group1011
    
The *No space left on device* error means we have reached the limit of defining ACLs on a given file, in this case:

    # getfacl testfile | grep -v \# | wc -l
    2026
    
We have done this kind of tests on lots of Operating Systems - overview:

|====
| OS Vendor      | OS Release    | File System type   | ACL limit
|----------------|---------------|--------------------|----------
| HP-UX          | 11.11         | vxfs               | 17
| HP-UX          | 11.23         | vxfs               | 1024
| HP-UX          | 11.31         | vxfs               | 1024
| RHEL           | 6.3           | ext3               | 508
| RHEL           | 6.6           | ext4               | 508
| RHEL           | 7.1           | xfs                | 26
| CentOS         | 7.0           | xfs                | 26
| Fedora         | 23            | xfs                | 8192
| SLES           | 10 SP4        | ext3               | 508
| SLES           | 11 SP2        | ext3               | 508
| SLES           | 12            | btrfs              | 2026
| Ubuntu         | 15.04         | ext4               | 508
|----------------|---------------|--------------------|----------
|====




To clean up the users and groups on your system run the same command with the *-c* option:

    # ./test-acl-bounderies.sh -c 2000
    ....
    no crontab for user2000
      -> Local account "user2000" has been successfully removed
      -> Local group group2000 has been successfully removed
    


Related links:

* [Access Control List](https://en.wikipedia.org/wiki/Access_control_list)
* [Source of test-acl-bounderies.sh](https://github.com/gdha/mismas/blob/master/test-acl-bounderies.sh)
* [masmas issues](https://github.com/gdha/mismas/issues)

