---
layout: post
title: How to modify the eject into delete key on the apple magic keyboard

description: How to modify the eject into delete key on the apple magic keyboard

tags: [terminal, it3 consultants]
author: gratien
---

<strong>How to modify the eject into delete key on the apple magic keyboard</strong>

The apple magic keyboard is a little nice keyboard that works well with Linux (Ubuntu 18.04), but there is no Delete key present. However, the keyboard contains an eject key that is not usable, and is in fact on the same spot as the delete key. So, why not redefine this key into delete?

* Clear the eject button functionality
  - Load System Settings
  - Select Keyboard
  - Select Shortcuts tab
  - Select the Sound and Media group
  - Click on Eject line
  - Hit the Backspace key to disable the eject function mapping

<img src="{{ site.url }}/images/settings-kbd.png" border="0" alt="Settings of keyboard layout"/>

* Map the delete function
  - Add "keycode 169 = Delete" to ~/.Xmodmap file
  - Make sure the .Xmodmap file gets loaded upon login
  - To load mapping immediately type: xmodmap ~/.Xmodmap

