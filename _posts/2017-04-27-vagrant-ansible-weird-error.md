---
layout: post
title: vagrant/ansible - Unexpected Exception ascii
description: Weird error with ansible and vagrant with ascii message
tags: [terminal, vagrant, ansible, Linux, Vagrantfile, it3 consultants]
author: gratien
---

<strong>vagrant/ansible - Unexpected Exception: ascii</strong>

When you ever see a weird message like:

    ==> client: Running provisioner: ansible_local...
    client: Running ansible-playbook...
    to see the full traceback, use -vvv
    ERROR! Unexpected Exception: 'ascii' codec can't encode character u'\u2018' in position 10: ordinal not in range(128)
    Ansible failed to complete successfully. Any error output should be
    visible above. Please fix these errors and try again.
    
Then do not try thousand of different things with the YAML files, but inspect the content of the YAML files with `cat -v` for some non-ascii characters. It can save you hours of troubleshooting!

    $ cat -v create_users.yml
    ---
    # File: ansible/common/roles/rear-test/tasks/create_users.yml
    
    - name: Generate password
      shell: python -c M-bM-^@M-^Ximport crypt; print crypt.crypt("vagrant", "$1$SomeSalt$")'
      register: genpass
    
As you can see in the above shell line the quote was a bad copy/paste from my side. Replaced it with a correct quote and the problem was fixed.

Happy debugging,
Gratien
