---
layout: post
title: Using mkdocs with GitHub pages (pitfalls)

description: Using mkdocs with GitHub pages (pitfalls)

tags: [terminal, docker, mkdocs, python, github, gh-pages, it3 consultants]
author: gratien
---

<strong>Using mkdocs with GitHub pages (pitfalls)</strong>

All of you using GitHub already probably heard about their new feature to publish your own static website of the project via [GitHub Pages](https://pages.github.com/). The default static pages generator for GitHub-pages is Jekyll, but we preferred to use [MkDocs](https://mkdocs.org) for generating our user guide with the style close to [Read the Docs](https://readthedocs.org/).

However, when you start reading the [help pages](https://docs.github.com/en/github/working-with-github-pages) on how to start with GitHub-pages (or gh-pages) then you active gh-pages via the 'Setting' of your project. That is fine if you stick to Jekyll and the themes gh-pages has available to you, but if you want to use mkdocs (or something else) do not active the gp-pages. Of course, I was using mkdocs and had to learn the hard way and activated gh-pages as follow:

<img src="{{ site.url }}/images/gh-pages-1.png" border="0" alt="github pages settings"/>

Followed by a `mkdocs gh-deploy` (which succeeded).

However, then you will get a page 404 (File not found) to see when you click on the URL shown above. The reason is that gp-pages (once activated via the Settings) only works fine when you use Jekyll as web page generator. I spent several hours to figure out how to fix this and tried several settings, but nothing worked. Until I stumbled over ["The Perfect Documentation Storm"](https://datamattsson.tumblr.com/post/612351271067893760/the-perfect-documentation-storm) page which made my euro-cent drop and realized that gp-pages may not be activated via settings (of the project page) to work with non-Jekyll static web page generators. Therefore, first delete the branch 'gh-pages' (via "code" -> "branches" -> "Delete the branch gh-pages"). Afterwards, go back to the "Settings" of your project and set the Source to "None" as show below:

<img src="{{ site.url }}/images/gh-pages-2.png" border="0" alt="github pages settings for mkdocs"/>

However, gh-pages requires the branch "gh-pages" to publish something on the web, therefore, do the following:

    gdha@velo:~/web$ mkdocs gh-deploy
    INFO    -  Cleaning site directory 
    INFO    -  Building documentation to directory: /home/gdha/web/site 
    INFO    -  Documentation built in 0.08 seconds 
    INFO    -  Copying '/home/gdha/web/site' to 'gh-pages' branch and pushing to GitHub. 
    INFO    -  Your documentation should shortly be available at: https://gdha.github.io/pi-stories/ 

And, finally, check the URL and you see the result on the Internet. This made my day and to avoid others to fall into the same pitfall I thought to share it with you all.

### References:

[1] [mkdocs](https://mkdocs.org)

[2] [GitHub Pages](https://pages.github.com/)

[3] [The Perfect Documentation Storm](https://datamattsson.tumblr.com/post/612351271067893760/the-perfect-documentation-storm)

### Edit history

- Initial post on 14 August 2020
