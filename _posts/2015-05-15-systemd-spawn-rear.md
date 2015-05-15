---
layout: post
title: Using systemd-nspawn to test rear rescue image
description:
tags: [terminal, Linux, Fedora, CentOS, RHEL, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Using systemd-nspawn to test rear rescue image</strong>

It is always a challenge to relay on the rescue image created by Relax-and-Recover (rear) if you cannot do a real boot test, right?
Well, you can just test it out almost immediately without doing a real boot test with systemd-nspawn. To do just run `rear -vd mkrescue`:

    # rear -vd mkrescue
    Relax-and-Recover 1.17.0 / Git
    Using log file: /var/log/rear/rear-braba.log
    Using UEFI Boot Loader for Linux (USING_UEFI_BOOTLOADER=1)
    Creating disk layout
    Creating root filesystem layout
    TIP: To login as root via ssh you need to set up /root/.ssh/authorized_keys or SSH_ROOT_PASSWORD in your configuration file
    Copying files and directories
    Copying binaries and libraries
    Copying kernel modules
    Creating initramfs
    Making ISO image
    Wrote ISO image: /var/lib/rear/output/rear-braba.iso (135M)
    You should also rm -Rf /tmp/rear.6PzAIYKf22D4uOL
    
It is important to use the `d` option with rear which keeps the temporary directories intact so that you can inspect these yourself. The above temporary rear directory contains some sub-directories like:

    # ls /tmp/rear.6PzAIYKf22D4uOL
    outputfs  rootfs  tmp
    
We need the *rootfs* directory as this contains a full populated rescue image. In the past the only debug command was the `chroot` command, like:

    # chroot /tmp/rear.6PzAIYKf22D4uOL/rootfs
    bash-4.2# ls
    bin  boot  dev	etc  init  lib	lib64  mnt  proc  root	run  sbin  selinux  sys  tmp  usr  var
   

However, with `systemd-nspawn` command we can really boot the rescue image. Isn't that cool?

    # systemd-nspawn -bD /tmp/rear.6PzAIYKf22D4uOL/rootfs/
    The kernel auditing subsystem is known to be incompatible with containers.
    Please make sure to turn off auditing with 'audit=0' on the kernel command
    line before using systemd-nspawn. Sleeping for 5s...
    Spawning namespace container on /tmp/rear.6PzAIYKf22D4uOL/rootfs (console is /dev/pts/2).
    Init process in the container running as PID 22291.
    Mounting cgroup to /sys/fs/cgroup/cpuset of type cgroup with options cpuset.
    Mounting cgroup to /sys/fs/cgroup/cpu,cpuacct of type cgroup with options cpu,cpuacct.
    Mounting cgroup to /sys/fs/cgroup/memory of type cgroup with options memory.
    Mounting cgroup to /sys/fs/cgroup/devices of type cgroup with options devices.
    Mounting cgroup to /sys/fs/cgroup/freezer of type cgroup with options freezer.
    Mounting cgroup to /sys/fs/cgroup/net_cls of type cgroup with options net_cls.
    Mounting cgroup to /sys/fs/cgroup/blkio of type cgroup with options blkio.
    Mounting cgroup to /sys/fs/cgroup/perf_event of type cgroup with options perf_event.
    Mounting cgroup to /sys/fs/cgroup/hugetlb of type cgroup with options hugetlb.
    systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
    Detected virtualization 'systemd-nspawn'.
    
    Welcome to CentOS Linux 7 (Core)!
    
    Initializing machine ID from random generator.
    Using cgroup controller name=systemd. File system hierarchy is at /sys/fs/cgroup/systemd/machine.slice/machine-rootfs.scope.
    Release agent already installed.
    Using notification socket @/org/freedesktop/systemd1/notify/16387626271585879236
    Set up TFD_TIMER_CANCEL_ON_SET timerfd.
    Successfully created private D-Bus server.
    Looking for unit files in (higher priority first):
	    /etc/systemd/system
	    /run/systemd/system
	    /usr/local/lib/systemd/system
	    /usr/lib/systemd/system
    Looking for SysV init scripts in:
	    /etc/rc.d/init.d
    Looking for SysV rcN.d links in:
	    /etc/rc.d
    Failed to load configuration for local-fs.target: No such file or directory
    Failed to load configuration for local-fs-pre.target: No such file or directory
    -.mount changed dead -> mounted
    proc-sys-kernel-random-boot_id.mount changed dead -> mounted
    etc-resolv.conf.mount changed dead -> mounted
    dev-dm\x2d1.swap changed dead -> active
    Activating default unit: default.target
    [/usr/lib/systemd/system/multi-user.target:13] Unknown lvalue 'Names' in section 'Unit'
    Failed to load configuration for plymouth-quit-wait.service: No such file or directory
    Failed to load configuration for systemd-user-sessions.service: No such file or directory
    Trying to enqueue job multi-user.target/start/isolate
    Installed new job multi-user.target/start as 1
    Installed new job sysinit.target/start as 2
    Installed new job systemd-udev-trigger.service/start as 4
    Installed new job systemd-udevd.service/start as 5
    Installed new job systemd-udevd-control.socket/start as 6
    Installed new job systemd-udevd-kernel.socket/start as 7
    Installed new job systemd-journald.service/start as 8
    Installed new job systemd-journald.socket/start as 9
    Installed new job sysinit.service/start as 10
    Installed new job basic.target/start as 11
    Installed new job sockets.target/start as 12
    Installed new job systemd-shutdownd.socket/start as 13
    Installed new job systemd-logger.socket/start as 14
    Installed new job syslog.socket/start as 15
    Installed new job dbus.socket/start as 16
    Installed new job system.slice/start as 17
    Installed new job -.slice/start as 18
    Installed new job sshd.service/start as 19
    Installed new job rear-boot-helper.service/start as 20
    Installed new job getty.target/start as 21
    Installed new job getty@tty4.service/start as 22
    Installed new job system-getty.slice/start as 23
    Installed new job getty@tty3.service/start as 24
    Installed new job getty@tty2.service/start as 25
    Installed new job getty@tty1.service/start as 26
    Enqueued job multi-user.target/start as 1
    Loaded units and determined initial transaction in 4.666ms.
             Starting Relax-and-Recover boot script...
    About to execute: /etc/scripts/boot
    Forked /etc/scripts/boot as 2
    rear-boot-helper.service changed dead -> start
    ConditionPathExists=/etc/inittab succeeded for sshd.service.
             Starting Relax-and-Recover sshd service...
    About to execute: /etc/scripts/run-sshd
    Forked /etc/scripts/run-sshd as 3
    sshd.service changed dead -> running
    Job sshd.service/start finished, result=done
    [  OK  ] Started Relax-and-Recover sshd service.
    -.slice changed dead -> active
    Job -.slice/start finished, result=done
    [  OK  ] Created slice -.slice.
    system.slice changed dead -> active
    Job system.slice/start finished, result=done
    [  OK  ] Created slice system.slice.
    system-getty.slice changed dead -> active
    Job system-getty.slice/start finished, result=done
    [  OK  ] Created slice system-getty.slice.
    syslog.socket changed dead -> listening
    Job syslog.socket/start finished, result=done
    [  OK  ] Listening on Syslog Socket.
    systemd-logger.socket changed dead -> listening
    Job systemd-logger.socket/start finished, result=done
    [  OK  ] Listening on Logging Socket.
    systemd-shutdownd.socket changed dead -> listening
    Job systemd-shutdownd.socket/start finished, result=done
    [  OK  ] Listening on Delayed Shutdown Socket.
    systemd-journald.socket changed dead -> listening
    Job systemd-journald.socket/start finished, result=done
    [  OK  ] Listening on Journal Socket.
             Starting Journal Service...
    About to execute: /usr/lib/systemd/systemd-journald
    Forked /usr/lib/systemd/systemd-journald as 4
    systemd-journald.service changed dead -> running
    Job systemd-journald.service/start finished, result=done
    [  OK  ] Started Journal Service.
    systemd-journald.socket changed listening -> running
    ConditionCapability=CAP_MKNOD failed for systemd-udevd-kernel.socket.
    Starting of systemd-udevd-kernel.socket requested but condition failed. Ignoring.
    Job systemd-udevd-kernel.socket/start finished, result=done
    ConditionCapability=CAP_MKNOD failed for systemd-udevd-control.socket.
    Starting of systemd-udevd-control.socket requested but condition failed. Ignoring.
    Job systemd-udevd-control.socket/start finished, result=done
    ConditionCapability=CAP_MKNOD failed for systemd-udevd.service.
    Starting of systemd-udevd.service requested but condition failed. Ignoring.
    Job systemd-udevd.service/start finished, result=done
             Starting udev Coldplug all Devices...
    About to execute: /usr/bin/udevadm trigger --type=subsystems --action=add
    Forked /usr/bin/udevadm as 7
    systemd-udev-trigger.service changed dead -> start
    sysinit.target changed dead -> active
    Job sysinit.target/start finished, result=done
    [  OK  ] Reached target System Initialization.
    dbus.socket changed dead -> listening
    Job dbus.socket/start finished, result=done
    [  OK  ] Listening on D-Bus System Message Bus Socket.
    sockets.target changed dead -> active
    Job sockets.target/start finished, result=done
    [  OK  ] Reached target Sockets.
    basic.target changed dead -> active
    Job basic.target/start finished, result=done
    [  OK  ] Reached target Basic System.
             Starting Initialize Rescue System...
    About to execute: /etc/scripts/system-setup
    Forked /etc/scripts/system-setup as 9
    sysinit.service changed dead -> start
    Set up jobs progress timerfd.
    Set up idle_pipe watch.
    Executing: /etc/scripts/system-setup
    * * * Configuring Rescue System * * *
    Running 00-functions.sh...
    Got notification message for unit systemd-journald.service
    systemd-journald.service: Got message
    systemd-journald.service: got STATUS=Processing requests...
    Got notification message for unit systemd-journald.service
    systemd-journald.service: Got message
    systemd-journald.service: got STATUS=Processing requests...
    Running 10-console-setup.sh...
    Received SIGCHLD from PID 3 (sshd).
    Child 3 (sshd) died (code=exited, status=255/n/a)
    Child 3 belongs to sshd.service
    sshd.service: main process exited, code=exited, status=255/n/a
    sshd.service changed running -> failed
    Unit sshd.service entered failed state.
    sshd.service: cgroup is empty
    Child 7 (udevadm) died (code=exited, status=0/SUCCESS)
    Child 7 belongs to systemd-udev-trigger.service
    systemd-udev-trigger.service: main process exited, code=exited, status=0/SUCCESS
    systemd-udev-trigger.service running next main command for state start
    About to execute: /usr/bin/udevadm trigger --type=devices --action=add
    Couldn't get a file descriptor referring to the console
    Forked /usr/bin/udevadm as 15
    Received SIGCHLD from PID 7 (n/a).
    Running 20-check-boot-options.sh...
    Received SIGCHLD from PID 2 (boot).
    Child 2 (boot) died (code=exited, status=0/SUCCESS)
    Child 2 belongs to rear-boot-helper.service
    rear-boot-helper.service: main process exited, code=exited, status=0/SUCCESS
    rear-boot-helper.service changed start -> dead
    Job rear-boot-helper.service/start finished, result=done
    [  OK  ] Started Relax-and-Recover boot script.
    rear-boot-helper.service: cgroup is empty
    Running 40-start-udev-or-load-modules.sh...
    Loading storage modules...
    Received SIGCHLD from PID 15 (udevadm).
    Child 15 (udevadm) died (code=exited, status=0/SUCCESS)
    Child 15 belongs to systemd-udev-trigger.service
    systemd-udev-trigger.service: main process exited, code=exited, status=0/SUCCESS
    systemd-udev-trigger.service changed start -> exited
    Job systemd-udev-trigger.service/start finished, result=done
    [  OK  ] Started udev Coldplug all Devices.
    systemd-udev-trigger.service: cgroup is empty
    Running 41-load-special-modules.sh...
    Running 42-engage-scsi.sh...
    Running 45-serial-console.sh...
    Accepted connection on private bus.
    Got D-Bus request: org.freedesktop.systemd1.Manager.Reload() on /org/freedesktop/systemd1
    Reloading.
    Serializing state to /run/systemd/dump-1-GgC13b
    Looking for unit files in (higher priority first):
	    /etc/systemd/system
	    /run/systemd/system
	    /usr/local/lib/systemd/system
	    /usr/lib/systemd/system
    Looking for SysV init scripts in:
	    /etc/rc.d/init.d
    Looking for SysV rcN.d links in:
	    /etc/rc.d
    Failed to load configuration for local-fs.target: No such file or directory
    Failed to load configuration for local-fs-pre.target: No such file or directory
    Deserializing state...
    [/usr/lib/systemd/system/multi-user.target:13] Unknown lvalue 'Names' in section 'Unit'
    Failed to load configuration for plymouth-quit-wait.service: No such file or directory
    Failed to load configuration for systemd-user-sessions.service: No such file or directory
    Reinstalled deserialized job multi-user.target/start as 1
    Reinstalled deserialized job sysinit.service/start as 10
    Reinstalled deserialized job getty.target/start as 21
    Reinstalled deserialized job getty@tty4.service/start as 22
    Reinstalled deserialized job getty@tty3.service/start as 24
    Reinstalled deserialized job getty@tty2.service/start as 25
    Reinstalled deserialized job getty@tty1.service/start as 26
    -.mount changed dead -> mounted
    proc-sys-kernel-random-boot_id.mount changed dead -> mounted
    system.slice changed dead -> active
    -.slice changed dead -> active
    etc-resolv.conf.mount changed dead -> mounted
    dev-dm\x2d1.swap changed dead -> active
    sysinit.target changed dead -> active
    systemd-udev-trigger.service changed dead -> exited
    systemd-journald.service changed dead -> running
    sysinit.service changed dead -> start
    sshd.service changed dead -> failed
    system-getty.slice changed dead -> active
    basic.target changed dead -> active
    sockets.target changed dead -> active
    systemd-shutdownd.socket changed dead -> listening
    systemd-logger.socket changed dead -> listening
    systemd-journald.socket changed dead -> running
    syslog.socket changed dead -> listening
    dbus.socket changed dead -> listening
    Closing left-over fd 37
    Got D-Bus request: org.freedesktop.DBus.Local.Disconnected() on /org/freedesktop/DBus/Local
    Running 55-migrate-network-devices.sh...
    Running 58-start-dhclient.sh...
    Attempting to start the DHCP client daemon
    dhclient: error while loading shared libraries: libomapi.so.0: cannot open shared object file: Permission denied
    dhclient: error while loading shared libraries: libomapi.so.0: cannot open shared object file: Permission denied
    dhclient: error while loading shared libraries: libomapi.so.0: cannot open shared object file: Permission denied
    dhclient: error while loading shared libraries: libomapi.so.0: cannot open shared object file: Permission denied
    dhclient: error while loading shared libraries: libomapi.so.0: cannot open shared object file: Permission denied
    Running 60-network-devices.sh...
    Running 62-routing.sh...
    Running 99-makedev.sh...
    * * * Rescue System is ready * * *
    Received SIGCHLD from PID 9 (system-setup).
    Child 9 (system-setup) died (code=exited, status=0/SUCCESS)
    Child 9 belongs to sysinit.service
    sysinit.service: main process exited, code=exited, status=0/SUCCESS
    sysinit.service changed start -> dead
    Job sysinit.service/start finished, result=done
    [  OK  ] Started Initialize Rescue System.
    Closed jobs progress timerfd.
    sysinit.service: cgroup is empty
             Starting Getty on tty4...
    About to execute: /sbin/agetty tty4 38400
    Forked /sbin/agetty as 787
    getty@tty4.service changed dead -> running
    Job getty@tty4.service/start finished, result=done
    [  OK  ] Started Getty on tty4.
             Starting Getty on tty3...
    About to execute: /sbin/agetty tty3 38400
    Forked /sbin/agetty as 788
    getty@tty3.service changed dead -> running
    Job getty@tty3.service/start finished, result=done
    [  OK  ] Started Getty on tty3.
             Starting Getty on tty2...
    About to execute: /sbin/agetty tty2 38400
    Forked /sbin/agetty as 789
    getty@tty2.service changed dead -> running
    Job getty@tty2.service/start finished, result=done
    [  OK  ] Started Getty on tty2.
             Starting Getty on tty1...
    About to execute: /sbin/agetty tty1 38400
    Forked /sbin/agetty as 790
    getty@tty1.service changed dead -> running
    Job getty@tty1.service/start finished, result=done
    [  OK  ] Started Getty on tty1.
    getty.target changed dead -> active
    Job getty.target/start finished, result=done
    [  OK  ] Reached target Login Prompts.
    multi-user.target changed dead -> active
    Job multi-user.target/start finished, result=done
    [  OK  ] Reached target Multi-User.
    Closed idle_pipe watch.
    Received SIGCHLD from PID 787 (agetty).
    Child 787 (agetty) died (code=exited, status=1/FAILURE)
    Child 787 belongs to getty@tty4.service
    getty@tty4.service: main process exited, code=exited, status=1/FAILURE
    getty@tty4.service changed running -> dead
    getty@tty4.service changed dead -> auto-restart
    getty@tty4.service: cgroup is empty
    Child 788 (agetty) died (code=exited, status=1/FAILURE)
    Child 788 belongs to getty@tty3.service
    getty@tty3.service: main process exited, code=exited, status=1/FAILURE
    getty@tty3.service changed running -> dead
    getty@tty3.service changed dead -> auto-restart
    getty@tty3.service: cgroup is empty
    Child 789 (agetty) died (code=exited, status=1/FAILURE)
    Child 789 belongs to getty@tty2.service
    getty@tty2.service: main process exited, code=exited, status=1/FAILURE
    getty@tty2.service changed running -> dead
    getty@tty2.service changed dead -> auto-restart
    getty@tty2.service: cgroup is empty
    Child 790 (agetty) died (code=exited, status=1/FAILURE)
    Child 790 belongs to getty@tty1.service
    getty@tty1.service: main process exited, code=exited, status=1/FAILURE
    getty@tty1.service changed running -> dead
    getty@tty1.service changed dead -> auto-restart
    getty@tty1.service: cgroup is empty
    Received SIGCHLD from PID 788 (n/a).
    getty@tty4.service holdoff time over, scheduling restart.
    Trying to enqueue job getty@tty4.service/restart/fail
    Installed new job getty@tty4.service/restart as 27
    Enqueued job getty@tty4.service/restart as 27
    getty@tty4.service scheduled restart job.
    getty@tty4.service changed auto-restart -> dead
    Job getty@tty4.service/restart finished, result=done
    Converting job getty@tty4.service/restart -> getty@tty4.service/start
    About to execute: /sbin/agetty tty4 38400
    Forked /sbin/agetty as 791
    getty@tty4.service changed dead -> running
    Job getty@tty4.service/start finished, result=done
    getty@tty3.service holdoff time over, scheduling restart.
    Trying to enqueue job getty@tty3.service/restart/fail
    Installed new job getty@tty3.service/restart as 42
    Enqueued job getty@tty3.service/restart as 42
    getty@tty3.service scheduled restart job.
    getty@tty3.service changed auto-restart -> dead
    Job getty@tty3.service/restart finished, result=done
    Converting job getty@tty3.service/restart -> getty@tty3.service/start
    About to execute: /sbin/agetty tty3 38400
    Forked /sbin/agetty as 792
    getty@tty3.service changed dead -> running
    Job getty@tty3.service/start finished, result=done
    getty@tty2.service holdoff time over, scheduling restart.
    Trying to enqueue job getty@tty2.service/restart/fail
    Installed new job getty@tty2.service/restart as 57
    Enqueued job getty@tty2.service/restart as 57
    getty@tty2.service scheduled restart job.
    getty@tty2.service changed auto-restart -> dead
    Job getty@tty2.service/restart finished, result=done
    Converting job getty@tty2.service/restart -> getty@tty2.service/start
    About to execute: /sbin/agetty tty2 38400
    Forked /sbin/agetty as 793
    getty@tty2.service changed dead -> running
    Job getty@tty2.service/start finished, result=done
    getty@tty1.service holdoff time over, scheduling restart.
    Trying to enqueue job getty@tty1.service/restart/fail
    Installed new job getty@tty1.service/restart as 72
    Enqueued job getty@tty1.service/restart as 72
    getty@tty1.service scheduled restart job.
    getty@tty1.service changed auto-restart -> dead
    Job getty@tty1.service/restart finished, result=done
    Converting job getty@tty1.service/restart -> getty@tty1.service/start
    About to execute: /sbin/agetty tty1 38400
    Forked /sbin/agetty as 794
    getty@tty1.service changed dead -> running
    Job getty@tty1.service/start finished, result=done
    Received SIGCHLD from PID 791 (agetty).
    Child 791 (agetty) died (code=exited, status=1/FAILURE)
    Child 791 belongs to getty@tty4.service
    getty@tty4.service: main process exited, code=exited, status=1/FAILURE
    getty@tty4.service changed running -> dead
    getty@tty4.service changed dead -> auto-restart
    getty@tty4.service: cgroup is empty
    getty@tty4.service holdoff time over, scheduling restart.
    Trying to enqueue job getty@tty4.service/restart/fail
    Installed new job getty@tty4.service/restart as 87
    Enqueued job getty@tty4.service/restart as 87
    getty@tty4.service scheduled restart job.
    getty@tty4.service changed auto-restart -> dead
    Job getty@tty4.service/restart finished, result=done
    Converting job getty@tty4.service/restart -> getty@tty4.service/start
    About to execute: /sbin/agetty tty4 38400
    Forked /sbin/agetty as 795
    getty@tty4.service changed dead -> running
    Job getty@tty4.service/start finished, result=done
    Received SIGCHLD from PID 792 (agetty).
    Child 792 (agetty) died (code=exited, status=1/FAILURE)
    Child 792 belongs to getty@tty3.service
    getty@tty3.service: main process exited, code=exited, status=1/FAILURE
    getty@tty3.service changed running -> dead
    getty@tty3.service changed dead -> auto-restart
    getty@tty3.service: cgroup is empty
    Child 793 (agetty) died (code=exited, status=1/FAILURE)
    Child 793 belongs to getty@tty2.service
    getty@tty2.service: main process exited, code=exited, status=1/FAILURE
    getty@tty2.service changed running -> dead
    getty@tty2.service changed dead -> auto-restart
    getty@tty2.service: cgroup is empty
    getty@tty3.service holdoff time over, scheduling restart.
    Trying to enqueue job getty@tty3.service/restart/fail
    Installed new job getty@tty3.service/restart as 102
    Enqueued job getty@tty3.service/restart as 102
    getty@tty3.service scheduled restart job.
    getty@tty3.service changed auto-restart -> dead
    Job getty@tty3.service/restart finished, result=done
    Converting job getty@tty3.service/restart -> getty@tty3.service/start
    About to execute: /sbin/agetty tty3 38400
    Forked /sbin/agetty as 796
    getty@tty3.service changed dead -> running
    Job getty@tty3.service/start finished, result=done
    Received SIGCHLD from PID 794 (agetty).
    Child 794 (agetty) died (code=exited, status=1/FAILURE)
    Child 794 belongs to getty@tty1.service
    getty@tty1.service: main process exited, code=exited, status=1/FAILURE
    getty@tty1.service changed running -> dead
    getty@tty1.service changed dead -> auto-restart
    getty@tty1.service: cgroup is empty
    
Unfortunately, the `agetty` processes seem to fail within `systemd-nspawn` process, and as such preventing from getting a real prompt.
