# Dockerfile to build/generate web-site www.it3.be
# docker build -t jekyll .
# docker run -it -v /home/gdha/projects/web/www.it3.be:/home/gdha/www.it3.be  -v /home/gdha/.netrc:/home/gdha/.netrc --net=host jekyll

FROM ubuntu:18.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    ruby-full \
    ruby-dev \
    make \
    gcc \
    locales \
    lftp \
    vim \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install ruby gems
RUN gem install jekyll \
    && gem install redcarpet \
    && gem install therubyracer

RUN useradd -u 1001 gdha && \
    mkdir -p /home/gdha/www.it3.be && \
    chown -R gdha:gdha /home/gdha

# Needed to make nerdtree plugin for vim work
RUN locale-gen en_US.UTF-8 && \
    echo "export LC_CTYPE=en_US.UTF-8" >> /home/gdha/.bashrc && \
    echo "export LC_ALL=en_US.UTF-8" >> /home/gdha/.bashrc

WORKDIR /home/gdha/www.it3.be
USER gdha
