---
layout: post
title: How to revert git commits

description: How to revert git commits

tags: [terminal, git, repositories, repo, sources, it3 consultants]
author: gratien
---

<strong>How to revert git commits</strong>

Sometimes we are too enthousiast and commit changes into our master tree to realize it was not meant to be?
The following is such an example:

    $ git log
    commit 0f0d1e77417c4fa17c10ea99c688e39a3b4efce7
    Author: Gratien D'haese <gratien.dhaese@gmail.com>
    Date:   Wed Sep 11 11:31:41 2019 +0200
    
         revert changes in function is_persistent_ethernet_name
    
    commit 9edc24f56bbb462f4ce67aa06af29a901918d95f
    Author: Gratien D'haese <gratien.dhaese@gmail.com>
    Date:   Tue Sep 10 09:28:36 2019 +0200
    
        Cosmetic fix for RHEL 6 and missing name_assign_type for LAN interfaces #2197
    
    commit b0347ff5d50dec02de934754f654ec20990b25a7
    Author: Gratien D'haese <gratien.dhaese@gmail.com>
    Date:   Wed Sep 11 11:31:41 2019 +0200
    
         revert changes in function is_persistent_ethernet_name
    
    commit c2418836157e693f0aba8b10c55c8ff48cdebad3
    Author: Gratien D'haese <gratien.dhaese@gmail.com>
    Date:   Tue Sep 10 09:28:36 2019 +0200
    
        Cosmetic fix for RHEL 6 and missing name_assign_type for LAN interfaces #2197
    
    commit a252ca20b5dc9f34f6c8fffb61e055141ca37669
    Merge: b8b7e46 6915bbd
    Author: Gratien D'haese <gratien.dhaese@gmail.com>
    Date:   Wed Sep 11 10:20:23 2019 +0200
    
        Merge pull request #2225 from goldzahn/master
        
        Use mountpoint instead of mount|grep
    
Well, after some time we realized that we should got back to the commit "a252ca20b5dc9f34f6c8fffb61e055141ca37669" and forget all the more recent commits. 

This is how it done quickly and rather easy:

    $ git branch temp a252ca20b5dc9f34f6c8fffb61e055141ca37669
    $ git rebase --onto temp master 
    First, rewinding head to replay your work on top of it...
    $ git branch -d temp
    Deleted branch temp (was a252ca2).
    $ git log
    commit a252ca20b5dc9f34f6c8fffb61e055141ca37669
    Merge: b8b7e46 6915bbd
    Author: Gratien D'haese <gratien.dhaese@gmail.com>
    Date:   Wed Sep 11 10:20:23 2019 +0200

We do hope it helps some poor folks struggling with this...
