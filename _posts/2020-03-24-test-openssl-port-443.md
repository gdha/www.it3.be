---
layout: post
title: How to test port 443 with the help of openssl

description: How to test port 443 with the help of openssl

tags: [terminal, openssl, it3 consultants]
author: gratien
---

<strong>How to test port 443 with the help of openssl</strong>

It is a simple task to see whether the remote server is responding on port 443 with the help of `openssl` command:

    #-> echo | openssl s_client -connect chefserver.scm.example.com:443 | grep CONNECTED
    depth=0 C = US, postalCode = 08933, ST = New York, L = wicked street = Plaza, O = Example, OU = Digital Hosting, CN = *.scm.example.com
    verify error:num=20:unable to get local issuer certificate
    verify return:1
    depth=0 C = US, postalCode = 08933, ST = New York, L = Wicked, street = Plaza, O = Example, OU = Digital Hosting, CN = *.scm.example.com
    verify error:num=21:unable to verify the first certificate
    verify return:1
    DONE
    CONNECTED(00000003)
    
As simple as that! Enjoy your day.
Of course, other manners of doing the same kind of test are possible. You may always comment to this post so others benefit from it. Thanks.

Gratien
