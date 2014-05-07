---
layout: post
title: How to fix git HEAD detached from a branch

description: How to resync the detached branch with the master again with git repositories

tags: [terminal, git, HEAD, detached, repositories, repo, sources, it3 consultants]
author: gratien
---

<strong>How to fix git HEAD detached from a branch</strong>

Today I had some weird going on with git and my master repository of rear. I could not `git commit` anymore without getting a message

    $ git commit rear-release-notes.txt
    # HEAD detached from rear-1.16
    

I had now commits in a branch named:

    $ git branch
    * (detached from rear-1.16)
      master
    

Ok, so I went back to the master branch:

    $ git checkout master
    Warning: you are leaving 2 commits behind, not connected to
    any of your branches:
    
      e9abc7a push release notes 1.16 (again)
      2f5d3fd adding the release notes for 1.16 to doc/
    
    If you want to keep them by creating a new branch, this may be a good time
    to do so with:
    
     git branch new_branch_name e9abc7a
    
    Switched to branch 'master'
    

Then I executed the following steps with a temporary branch `temp` to get the missing commits back into the master branch.

    $ git branch temp e9abc7a
    $ git checkout temp
    Switched to branch 'temp'
    $ git branch
      master
    * temp
    $ git log --graph --decorate --pretty=oneline --abbrev-commit master origin/master temp
    * e9abc7a (HEAD, temp) push release notes 1.16 (again)
    * 2f5d3fd adding the release notes for 1.16 to doc/
    * 4581e52 (tag: rear-1.16, origin/master, origin/HEAD, master) prepare rear for new release 1.16
    *   de337d4 Merge pull request #403 from ypid/df-encfs-fix
    
    $ git diff master temp
    diff --git a/doc/rear-release-notes.txt b/doc/rear-release-notes.txt
    ....
    
    $ git diff origin/master temp
    diff --git a/doc/rear-release-notes.txt b/doc/rear-release-notes.txt
    ....
    $ git branch -f master temp
    $ git checkout master
    Switched to branch 'master'
    Your branch is ahead of 'origin/master' by 2 commits.
      (use "git push" to publish your local commits)
    $ git push
    $ git branch -d temp
    Deleted branch temp (was e9abc7a).
    
That is all.


