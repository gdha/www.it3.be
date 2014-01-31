---
layout: post
title: When lazy umount is not enough?

description: The famous stale NFS issue that keeps coming back

tags: [terminal, linux, NFS, stale NFS, df hangs, howto, it3 consultants]
author: gratien
---

<strong>How to get rid of stale NFS mount points?</strong>

The internal famous `df` hang on stale NFS mount points is not going away it seems. Sometimes it is very hard to get rid of those NFS mount points. You can do a force umount or a lazy umount, but still it is not going away. Well, here are some tricks that might help:

    #-> mount | grep RAB
    dbciRAB:/export/sapmnt/RAB on /sapmnt/RAB type nfs (rw,hard,bg,intr,addr=10.153.170.31)
    
    #-> grep RAB /var/log/messages
    Jan 30 08:28:19 sap73 kernel: [20425037.280109] nfs: server dbciRAB not responding, still trying
    Jan 30 08:31:41 sap73 kernel: [20425239.008114] nfs: server dbciRAB not responding, still trying
    
    #-> timeout 10 df /sapmnt/RAB ; echo $? 
    124
    
    #-> timeout 10 fuser /sapmnt/RAB ; echo $?
    124

    #-> ping 10.153.170.31
    PING 10.153.170.31 (10.153.170.31) 56(84) bytes of data.
    
    --- 10.153.170.31 ping statistics ---
    2 packets transmitted, 0 received, 100% packet loss, time 1001ms

Ok, what have we learned? The NFS server is not responding, so indeed this is a stale NFS issue. You might want to try a last time (forced and lazy umount):

    #-> umount -f -l /sapmnt/RAB
    ^C
    
    #-> mount | grep "/sapmnt/RAB"
    dbciRAB:/export/sapmnt/RAB on /sapmnt/RAB type nfs (rw,hard,bg,intr,addr=10.153.170.31)

However, still no luck. Time for some drastic commands. Be aware the following will `umount` all NFS related file systems, so first list them up via a plain `mount | grep -i nfs` command. Then, execute the following:

    #->  /etc/init.d/nfs restart
    Shutting down NFS client services:umount.nfs: /sapmnt/RDB: device is busy
    umount.nfs: /sapmnt/RAB: device is busy
    umount.nfs: /sapmnt/RSB: device is busy
     rpc.statd                                                                                                               done
    Starting NFS client services:
    ^C

Almost a success, but it seems to get stuck on the `checkproc` command, but we interrupt it here (as we do not want to wait forever, do we). Check if the stale NFS is gone:

    #-> mount | grep "/sapmnt/RAB"

Yes, it is. Let us start the stat daemon manual again with the command:

    #-> /usr/sbin/start-statd

And, check it all NFS client processes are running with `ps ax | grep rpc` (you should see `rpc.statd`, `rpcbind` and `rpciod` in the list). Finally, remount the NFS file systems that disappeared during the restart of the NFS client daemons.
Do the final test with the `df` command to be 100% sure that there are no stale NFS links around.

By the way, there is a second trick if the above is not enough and that is making an alias of the IP address of the NFS server that is not responding (in out example this is aIP address 10.153.170.31). We make a fake NFS alias with the command:

    #-> ip a
    #-> fconfig bond0:fakenfs 10.153.170.31 netmask 255.255.255.255
    #-> ip a
    10: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
        link/ether 28:92:4a:31:55:d0 brd ff:ff:ff:ff:ff:ff
        inet 10.130.208.103/23 brd 10.130.209.255 scope global bond0
        inet 10.153.170.31/32 brd 10.255.255.255 scope global bond0:fakenfs
    #-> ping 10.153.170.31
    PING 10.153.170.31 (10.153.170.31) 56(84) bytes of data.
    64 bytes from 10.153.170.31: icmp_seq=1 ttl=64 time=0.067 ms


Now you could try the usual `umount -f -l` trick and you might be lucky. Of course, once succeeded do not forget to remove the alias again with the following command:

    #-> ip addr del 10.153.170.31/32 dev bond0

Hope you may find this article useful.

