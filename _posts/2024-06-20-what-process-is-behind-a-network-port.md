---
layout: post
title: What process is behind a network port?

description: What process is behind a network port?

tags: [linux, network, network port, howto, it3 consultants]
author: gratien
---

<strong>What process is behind a network port?</strong>

Did you ever wonder if you type e.g. `netstat -an | grep 8110`, and you get as response:

```bash
$ netstat -an | grep 8110
tcp        0      0 0.0.0.0:8110            0.0.0.0:*               LISTEN
```
what process is listening to this port 8110?

Well, there are two ways to find out:

- One method is by using the `netstat` command with some smarter options used:

```bash
$ netstat -tulpn | grep LISTEN
tcp        0      0 0.0.0.0:8110            0.0.0.0:*               LISTEN      14970/wd.sapZD0_W00
```

- Second method is by using the `ss` command:

```bash
$ ss -tlpn
State      Recv-Q      Send-Q      Local Address:Port      Peer Address:Port     Process
LISTEN     0           512         0.0.0.0:8110            0.0.0.0:*             users:(("wd.sapZD0_W00",pid=14970,fd=17))
```

Nothing special, but handy to remember.
