---
layout: post
title: Procedure to sign your own RPMs

description: Procedure to sign your own RPMs

tags: [terminal, cryptography, GnuPG, gpg, rpm, linux, howto, it3 consultants]
author: gratien
---

<strong>Procedure to sign your own RPMs</strong>

It is a good (security) practice to sign your own RPMs with your GnuPG cryptographic key to proof who is responsible for the RPM and it proofs that you are the owner.

First of all, you need to install and [generate GnuPG cryptographic keys](/2014/02/14/gnupg-key-generation/).

To view your GnuPG keys use the following command:

    $ gpg --list-keys
    /home/gdha/.gnupg/pubring.gpg
    -----------------------------
    pub   4096R/B34AC2BF 2017-07-17
    uid                  Gratien Dhaese (GitHub key) <gratien.dhaese@gmail.com>
    uid                  Gratien Dhaese <gratien.dhaese@gmail.com>
    sub   4096R/16B9E33B 2017-07-17
    
Another useful command to view the current public RPM GnuPG keys installed:

     $  rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'
     gpg-pubkey-f4a80eb5-53a7ff4b	gpg(CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>)
     gpg-pubkey-5044912e-4b7489b1	gpg(Dropbox Automatic Signing Key <linux@dropbox.com>)
     gpg-pubkey-352c64e5-52ae6884	gpg(Fedora EPEL (7) <epel@fedoraproject.org>)
     gpg-pubkey-98ab5139-4bf2d0b0	gpg(Oracle Corporation (VirtualBox archive signing key) <info@virtualbox.org>)
     gpg-pubkey-85c6cd8a-4e060c35	gpg(Nux.Ro (rpm builder) <rpm@li.nux.ro>)
     gpg-pubkey-725a0c43-54944ee4	gpg(Archiving OBS Project <Archiving@build.opensuse.org>)
     gpg-pubkey-baadae52-49beffa4	gpg(elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>)
     

It is the purpose that we add our own GnuPG public key to the list of public RPM GnuPG keys. Therefore, we need first to
export our own public GnuPG key as follows:

    $ gpg --export -a "Gratien Dhaese <gratien.dhaese@gmail.com>" > ~/.gnupg/RPM-GPG-KEY-gratien-dhaese
    $ head  ~/.gnupg/RPM-GPG-KEY-gratien-dhaese
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    Version: GnuPG v2.0.22 (GNU/Linux)
    
    mQINBFlslqoBEACzUWiasqzjacS+0qaz3MD5b7vsSY8NxR321DHzcOoeuRjJWGK1
    ....                            


We need to copy our exported public GnuPG rpm key to `/etc/pki/rpm-gpg`:

    $ /etc/pki/rpm-gpg/
    RPM-GPG-KEY-CentOS-7        RPM-GPG-KEY-CentOS-Testing-7  RPM-GPG-KEY-EPEL-7
    RPM-GPG-KEY-CentOS-Debug-7  RPM-GPG-KEY-elrepo.org        RPM-GPG-KEY-nux.ro
    $ sudo cp ~/.gnupg/RPM-GPG-KEY-gratien-dhaese /etc/pki/rpm-gpg


Now we are able to import our key into RPMs key list:
    
    $ sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-gratien-dhaese
    $ rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'
    gpg-pubkey-f4a80eb5-53a7ff4b	gpg(CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>)
    gpg-pubkey-5044912e-4b7489b1	gpg(Dropbox Automatic Signing Key <linux@dropbox.com>)
    gpg-pubkey-352c64e5-52ae6884	gpg(Fedora EPEL (7) <epel@fedoraproject.org>)
    gpg-pubkey-98ab5139-4bf2d0b0	gpg(Oracle Corporation (VirtualBox archive signing key) <info@virtualbox.org>)
    gpg-pubkey-85c6cd8a-4e060c35	gpg(Nux.Ro (rpm builder) <rpm@li.nux.ro>)
    gpg-pubkey-725a0c43-54944ee4	gpg(Archiving OBS Project <Archiving@build.opensuse.org>)
    gpg-pubkey-baadae52-49beffa4	gpg(elrepo.org (RPM Signing Key for elrepo.org) <secure@elrepo.org>)
    gpg-pubkey-b34ac2bf-596c96aa	gpg(Gratien Dhaese (GitHub key) <gratien.dhaese@gmail.com>)


Then, to use it with rpm build add the following lines to your personal .rpmmacros file:

    $ cat >> ~/.rpmmacros <<EOF
    %_signature gpg
    %_gpg_name Gratien Dhaese (GitHub key) <gratien.dhaese@gmail.com>
    EOF

Finally, we come to the reason why we wrote this short blog is signing a RPM:

    $ rpm -qpi ~/RPM/RPMS/x86_64/rear-workshop-1.0-1.el7.centos.x86_64.rpm | grep Sign
    Signature   : (none)
    $ rpm --resign ~/RPM/RPMS/x86_64/rear-workshop-1.0-1.el7.centos.x86_64.rpm
    Enter pass phrase: 
    Pass phrase is good.
    /home/gdha/RPM/RPMS/x86_64/rear-workshop-1.0-1.el7.centos.x86_64.rpm:
    $ rpm -qpi ~/RPM/RPMS/x86_64/rear-workshop-1.0-1.el7.centos.x86_64.rpm | grep Sign
    Signature   : RSA/SHA1, Wed 25 Oct 2017 06:13:59 PM CEST, Key ID 9ad6bf40b34ac2bf


Reference: [Create a yum repository with custom GPG-signed RPM packages](http://linuxsysconfig.com/2013/04/create-a-yum-repository-with-custom-gpg-signed-packages/)
