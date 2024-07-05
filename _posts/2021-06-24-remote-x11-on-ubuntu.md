---
layout: post
title: How to remotely display X11 application on an Ubuntu 20 desktop

description: How to remotely display X11 application on an Ubuntu 20 desktop

tags: [Open Source, Ubuntu, X11, it3 consultants, Desktop, Remote]
author: gratien
---

<strong>How to remotely display X11 application on an Ubuntu 20 desktop</strong>

#### On the client Ubuntu Desktop system

An Ubuntu 20 desktop is by default not supporting displaying remote X11 based applications as Ubuntu X Windows system is based on Wayland instead of the one from X.org. You can easily check this with the command:

```bash
$ echo $XDG_SESSION_TYPE
wayland
```

When you see as output `wayland` instead of `x11` then you know we have some work to perform to allow remote X11 application to be able to pop-up on our Ubuntu desktop. To modify this please edit the /etc/gdm3/custom.conf file and uncomment the WaylandEnable line as follows and restart the system:

```bash
# Uncomment the line below to force the login screen to use Xorg
WaylandEnable=false
```

Finally, to accept x11 applications add the following to your personal Secure Shell config file (`$HOME/.ssh/config`) as global variables:

```bash
ForwardAgent yes
ForwardX11 yes
ForwardX11Trusted yes
```

#### On the remote system where the x11 application runs

To allow X11 forwarding on the remote system we also need to make sure that in the `/etc/ssh/ssh_config` file (not your local Ubuntu desktop system) we uncomment or add the following lines:

```bash
#   ForwardAgent no
    ForwardX11 yes
    ForwardX11Trusted yes
```

Furthermore, also edit the `/etc/ssh/sshd_config` file and define the following settings:

```bash
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost no
```

The `X11UseLocalhost no` setting is required to avoid the error message `X11 forwarding request failed on channel 0` [2].

And finally, restart the Secure Shell daemon (sshd) with the command : `systemctl restart sshd`

#### The Remote X11 test

From your Ubuntu desktop (via a terminal window) login on the remote server from where you want to launch a x11 application and get it visible on your Ubuntu desktop. Therefore, use the following command:

```bash
DISPLAY=:1 ssh -X n5
```

The `-X` flag means we want to forward X11 displays and when you type the command `echo $DISPLAY` (on the remote system) you will see it echos:

```bash
n5:10.0
```

Now, you can launch any available x11 application and get it projected on your Ubuntu desktop, e.g. `xmessage "Hello from system $(hostname)"`

#### References

[1] [Displaying Ubuntu 20.04 Applications Remotely (X11 Forwarding)](https://www.answertopia.com/ubuntu/displaying-ubuntu-applications-remotely-x11-forwarding/)

[2] [X11 forwarding request failed on channel 0 Error and Solution](https://www.cyberciti.biz/faq/how-to-fix-x11-forwarding-request-failed-on-channel-0/)
