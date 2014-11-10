www.it3.be
==========


This repo contains a [Jekyll](https://github.com/mojombo/jekyll) templated site made
to deploy on the web.

### Software pre-requisites

You need `jekyll` to build this web site, therefore, install with the command:

```shell
$ sudo yum install ruby ruby-devel rubygems
$ sudo gem install jekyll
$ sudo gem install redcarpet
$ sudo gem install therubyracer  (required on CentOS 7)
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
