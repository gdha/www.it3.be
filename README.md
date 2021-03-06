www.it3.be
==========


This repo contains a [Jekyll](https://github.com/mojombo/jekyll) templated site made
to deploy on the web.

### Software pre-requisites

You need `jekyll` to build this web site, therefore, install with the command:

```shell
$ sudo yum group install "C Development Tools and Libraries"   (Fedora)
$ sudo yum group install "Development Tools"   (CentOS, RHEL)
$ sudo yum install ruby ruby-devel rubygems
$ sudo gem install jekyll
$ sudo gem install redcarpet
$ sudo gem install therubyracer
```

### Run Locally

To run the server (default port 4000), clone the repo and run from the root directory:

With older versions then `jekyll 1.0.3` use:

```shell
jekyll --server
```

With `jekyll 1.0.3` or higher versions use:

```shell
jekyll server
```

If you want to just compile the code (into the `_site` directory):

With older versions then `jekyll 1.0.3` use:

```shell
jekyll --no-server
```

With `jekyll 1.0.3` or higher versions use:

```shell
jekyll build
```

Upgrade Issues with Jekyll with [Permalinks no longer automatically add a trailing slash](https://jekyllrb.com/docs/upgrading/2-to-3/#permalinks-no-longer-automatically-add-a-trailing-slash) are possible - if it hits you then you know what to do.
