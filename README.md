www.it3.be
==========


This repo contains a [Jekyll](https://github.com/mojombo/jekyll) templated site made
to deploy on the web.

### Software pre-requisites

You need `jekyll` to build this web site, therefore, install with the command:

```shell
$ sudo yum install ruby ruby-devel
$ sudo gem install jekyll
$ sudo gem install redcarpet
```

### Run Locally

To run the server (default port 4000), clone the repo and run from the root directory:

```shell
jekyll --server
```

If you want to just compile the code (into the `_site` directory):

```shell
jekyll --no-server
```
