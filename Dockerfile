# Dockerfile to build/generate web-site www.it3.be
# docker build -t jekyll --build-arg local_user=gdha --build-arg local_id=1002 .
# docker run -it -v /home/gdha/projects/web/www.it3.be:/home/gdha/www.it3.be  -v /home/gdha/.netrc:/home/gdha/.netrc \
# -v /home/gdha/.gitconfig:/home/gdha/.gitconfig -v /home/gdha/.ssh:/home/gdha/.ssh \
# -v /home/gdha/.gnupg:/home/gdha/.gnupg  --net=host jekyll
# Afterwards we can just start the container as:
# docker start -i jekyll

FROM ubuntu:20.04
ARG local_user=gdha
ARG local_id=1002
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    ruby-full \
    ruby-dev \
    rubygems-integration \
    make \
    gcc \
    curl \
    ca-certificates \
    git \
    openssh-client \
    gnupg \
    locales \
    lftp \
    vim \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install ruby gems
RUN gem install jekyll --version="~> 4.2.0" \
    && gem install redcarpet \
    && gem install therubyracer

RUN useradd -u ${local_id} ${local_user} && \
    mkdir -p /home/${local_user}/www.it3.be && \
    chown -R ${local_user}:${local_user} /home/${local_user}

# Needed to make nerdtree plugin for vim work
RUN locale-gen en_US.UTF-8 && \
    echo "export LC_CTYPE=en_US.UTF-8" >> /home/${local_user}/.bashrc && \
    echo "export LC_ALL=en_US.UTF-8" >> /home/${local_user}/.bashrc

WORKDIR /home/${local_user}/www.it3.be
USER ${local_user}
