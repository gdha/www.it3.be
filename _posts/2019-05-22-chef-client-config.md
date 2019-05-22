---
layout: post
title: Preventing adding chef client configuration with knife command
description: Tured of appending "-c /etc/chef/client.db" with the knife command?
tags: [chef, knife, linux, it3 consultants]
author: gratien
---

<strong>Preventing adding chef client configuration with knife command</strong>

The knife command useally needs root privileges on Chef client systems not using ChefDK (read Chef Workstation). And, if the `client.rb` configuration is not located under the `/root/.chef` directory, but under `/etc/chef` directory then we need to type the following with a `knife` command:

    #-> knife data bag list -c /etc/chef/client.rb

However, after doing such commands many times a day it becomes cumbersome to so so. How can we get rid of the `-c /etc/chef/client.rb` part?

If we tried the same command without the configuration setting we got:

    #-> knife data bag list
    WARNING: No knife configuration file found
    WARN: Failed to read the private key /etc/chef/client.pem: #<Errno::ENOENT: No such file or directory @ rb_sysopen - /etc/chef/client.pem>
    ERROR: Your private key could not be loaded from /etc/chef/client.pem
    Check your configuration file and ensure that your private key is readable 

Well, it seems not that difficult. The `knife` commands always searches the `$HOME/.chef` directory first for a valid client configuration file. In our case the HOME variable was translated to `/root/.chef`. Furthermore, if under the `/root/.chef` directory there is no configuration file such as `config.rb`, `knife.rb` or `client.rb` then we can fix this as follow:

    #-> ln -s /etc/chef/client.rb /root/.chef/knife.rb

From that moment on there is no need anymore to append the `-c /etc/chef/client.rb` to any `knife` command. Great that saves me time!

Another related post I found to very useful was [Configure Chef on Linux](https://www.bonusbits.com/wiki/HowTo:Configure_Knife_on_Linux)

Have fun, Gratien
