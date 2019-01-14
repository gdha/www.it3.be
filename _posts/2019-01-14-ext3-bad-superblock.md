---
layout: post
title: Mounting an ext3 file system fails with bad superblock error

description: Mounting an ext3 file system fails with bad superblock error

tags: [terminal, AWS, RHEL, linux, howto, it3 consultants]
author: gratien
---

<strong>Mounting an ext3 file system fails with bad superblock error</strong>

It happens sometimes (luckely not very often) that the primary superblock of an ext2, ext3 file system gets corrupted. This results in a mount failure of that file system which is not pleasant, however, it can be fixed because these types of file systems have also backup superblock to recover from. We just need to list them up with the command:

    # dumpe2fs /dev/sd<device number> | grep superblock
    dumpe2fs 1.41.12 (17-May-2010)
      Primary superblock at 0, Group descriptors at 1-1
      Backup superblock at 32768, Group descriptors at 32769-32769
      Backup superblock at 98304, Group descriptors at 98305-98305
      Backup superblock at 163840, Group descriptors at 163841-163841
      Backup superblock at 229376, Group descriptors at 229377-229377
      Backup superblock at 294912, Group descriptors at 294913-294913
      Backup superblock at 819200, Group descriptors at 819201-819201
      Backup superblock at 884736, Group descriptors at 884737-884737
      Backup superblock at 1605632, Group descriptors at 1605633-1605633

Then use one of the listed backup superblock numbers with a file system check:

    # fsck -b 32768 /dev/sd<device number>

Once a successful file system check has been performed the mount operation should work now.

Enjoy - Gratien
