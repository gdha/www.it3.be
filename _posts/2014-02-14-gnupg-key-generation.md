---
layout: post
title: Generating GnuPG cryptographic keys

description: How-to generate GnuPG cryptographic keys with gpg

tags: [terminal, cryptography, GnuPG, gpg, howto, it3 consultants]
author: gratien
---

<strong>How to generate GnuPG cryptographic keys with gpg</strong>

[GNU Privacy Guard (GnuPG or GPG)](http://en.wikipedia.org/wiki/Gnupg) is a cryptographic program to generate encryption keys which can be used in any kind of program, such mail clients, instant messaging, or applications (duplicity). 

We can use `gpg` to encrypt or decrypt plain files, but you could (and should) use it in combination with cloud based disaster recovery storage. The `duplicity` program is able to make use of this encryption keys.

    $ gpg --gen-key
    gpg (GnuPG) 1.4.16; Copyright (C) 2013 Free Software Foundation, Inc.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    
    Please select what kind of key you want:
       (1) RSA and RSA (default)
       (2) DSA and Elgamal
       (3) DSA (sign only)
       (4) RSA (sign only)
    Your selection? 2

We select option "2" because we want encryption keys that can be used by cloud based software such as duplicity.
The next question is the key length. If you are seeking for a local solution as encrypting files then choose 2048 (which is the default). However, if it is the purpose to encrypt large archives (towards cloud based storage) then we advise to use 1024 bits instead.

    DSA keys may be between 1024 and 3072 bits long.
    What keysize do you want? (2048) 1024
    Requested keysize is 1024 bits

The next question is the time before the generated keys expire. We tend to use a longer period such as three years.

    Please specify how long the key should be valid.
             0 = key does not expire
          <n>  = key expires in n days
          <n>w = key expires in n weeks
          <n>m = key expires in n months
          <n>y = key expires in n years
    Key is valid for? (0) 3y
    Key expires at Sun 05 Feb 2017 08:51:16 AM CET
    Is this correct? (y/N) y
    

The during the key generating process it is requesting the identity for whom the keys are ment:

    You need a user ID to identify your key; the software constructs the user ID
    from the Real Name, Comment and Email Address in this form:
        "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"
    
    Real name: Gratien D'haese
    Email address: gratien.dhaese@it3.be
    Comment:
    You selected this USER-ID:
        "Gratien D'haese <gratien.dhaese@it3.be>"
    
Once you select the "okay" then you will be prompted for a secure passphrase. Please do *not* forget this key, otherwise, your encryption keys will be completely unusable! Furthermore, it is important to store your passphrase in a secure place such as KeePass.

    Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
    You need a Passphrase to protect your secret key.
    
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    .++++++++++++++++++++..+++++.+++++++++++++++.++++++++++++++++++++++++++++++.+++++.+++++++++++++++++++++++++.+++++++++++++++.+++++.++++++++++>++++++++++......................................>+++++.................+++++
    We need to generate a lot of random bytes. It is a good idea to perform
    some other action (type on the keyboard, move the mouse, utilize the
    disks) during the prime generation; this gives the random number
    generator a better chance to gain enough entropy.
    +++++++++++++++++++++++++++++++++++...+++++.+++++.++++++++++++++++++++++++++++++.++++++++++.++++++++++++++++++++++++++++++..++++++++++.+++++>..+++++....................+++++^^^^
    gpg: key 72624EFE marked as ultimately trusted
    public and secret key created and signed.
    
    gpg: checking the trustdb
    gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
    gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
    gpg: next trustdb check due at 2017-02-05
    pub   1024D/72624EFE 2014-02-06 [expires: 2017-02-05]
          Key fingerprint = A472 0E8D FA61 C84F F7A0  0D96 DB9D EC9F 7262 4EFE
    uid                  Gratien D'haese <gratien.dhaese@it3.be>
    sub   1024g/6A44AFF2 2014-02-06 [expires: 2017-02-05]

The key-id is in above case (yours will be different of course) is *72624EFE*. You could add this key in your shell profile (e.g. `~/.bashrc`)

    export GPGKEY=72624EFE

To test if it works properly try to encrypt a file:

    $ gpg -o BC-exec.gpg --encrypt -r 72624EFE BC-exec.sh

And, then try to decrypt the above generated encrypted `BC-exec.gpg` file as

    $ gpg --decrypt BC-exec.gpg
    
    You need a passphrase to unlock the secret key for
    user: "Gratien D'haese <gratien.dhaese@it3.be>"
    1024-bit ELG-E key, ID 6A44AFF2, created 2014-02-06 (main key ID 72624EFE)
    
    gpg: encrypted with 1024-bit ELG-E key, ID 6A44AFF2, created 2014-02-06
          "Gratien D'haese <gratien.dhaese@it3.be>"
    #!/usr/bin/ksh
    #
    # This script will perform several activities related to Business Copy,
    # like pairsplit, pairesync, LVM and filesystem operations, etc.
    ....

Related links:
* [Beginners Guide to GnuPG](http://ubuntuforums.org/showthread.php?t=680292)
* [GnuPrivacyGuardHowto](https://help.ubuntu.com/community/GnuPrivacyGuardHowto)
