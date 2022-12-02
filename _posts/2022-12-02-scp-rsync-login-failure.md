---
layout: post
title: scp or rsync login failure due to echo in .bashrc

description: How to fix a scp or rsync failure due to an echo in .bashrc?

tags: [Open Source, Linux, scp, rsync, it3 consultants, unexpected, error]
author: gratien
---

<strong>How to fix a scp or rsync failure due to an echo in .bashrc?</strong>

Did you ever had the following issue with scp:

```bash
protocol error: unexpected <newline>
```

Or with rsync:

```bash
rsync error protocol incompatibility
```

Well, it happened to us and the reason is an `echo` command in the `~/.bashrc` file!

There are two ways to fix it:

1. remove the echo command, but it was there on purpose, right?
2. Add the following section to your `~/.bashrc` file:

```bash
if [[ $- != *i* ]] ; then
  # shell is non-interactive - do a silent return
  return
fi
```

And, the problems go away. Neat trick, no?

