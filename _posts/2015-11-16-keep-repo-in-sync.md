---
layout: post
title: Procedure to keep your forked repo in sync with the upstream
description:
tags: [terminal, Linux, ebosi, git, repo, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Procedure to keep your forked repo in sync with the upstream</strong>

Developers using git are probably using the "fork" possibility that GitHub provides to work on their own copy of the sources. However, sometimes it is handy to sync your working copy (repo) with the upstream repo of the core developers (owner of the sources).

Personally we work on the project [ebiso](https://github.com/gozora/ebiso/wiki) from time to time. Therefore, we need to sync with the upstream before starting to work on our own copy of the repo. Working this way makes it much easier for the owner to read through the pull request we provide. As an example, with rear we get sometimes pull requests that contain updates we pushed months ago into our upstream. To prevent this, first sync with the upstream before making your changes. You read it well, I repeat, *first sync with the upstream*!

Of course, first of all you need to *fork* a copy of the sources at the upstream GitHub home page of the sources. This part is explained well in the tutorial 'Keeping your forked repo synced with the upstream source'. To clone your copy of the fork you need to go to your personal home page of GitHub and select the new *forked* project and copy the URL provided.

On a bash prompt you can then clone the fork to your own dircetories as follow:

    $ git clone git@github.com:gdha/ebiso.git

This is your *master* branch as you can see with the command:

    $ cd ebiso
    $ git branch
    * master

Then, and this is the most crucial part, is to make your branch aware of the upstream master (you only need to do this once):

    $ git  remote add upstream git@github.com:gozora/ebiso.git

To verify that your copy has been successfully linked with the upstream type:

    $ git remote
    origin
    upstream

Now, to rebase (or sync) with the upstream repo you have to make sure that you are currently working with your *master* repo (use `git branch` to verify) and then do the following:

    $ git fetch upstream
    $ git rebase upstream/master
    $ git status


And finally, push your updates to your own copy of the master (your fork) after working on it:

    $ git push origin master

Then, when you are satisfied, with your changes (commits) you may request for a pull request at your project GitHub page towards to upstream maintainer. That is in a nutshell how to keep the repo's in sync.

Gratien

Related links:

* [Keeping your forked repo synced with the upstream source](http://2buntu.com/articles/1459/keeping-your-forked-repo-synced-with-the-upstream-source/)
* [Upstream source of ebiso at GitHub](https://github.com/gozora/ebiso)
* [Gratien fork of ebiso](https://github.com/gdha/ebiso)

