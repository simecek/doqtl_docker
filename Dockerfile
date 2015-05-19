## Emacs, make this -*- mode: sh; -*-

## Experiment based on rocker repository
## Original authors Carl Boettiger and Dirk Eddelbuettel

FROM debian:testing

## This handle reaches Carl and Dirk
MAINTAINER "Petr Simecek" lamparna@gmail.com

## Set a default user. Available via runtime flag `--user docker` 
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly). 
RUN useradd docker \
&& mkdir /home/docker \
&& chown docker:docker /home/docker \
&& addgroup docker staff

RUN apt-get update \ 
&& apt-get install -y --no-install-recommends \
ed \
less \
locales \
vim-tiny \
wget \
&& rm -rf /var/lib/apt/lists/*
  
  ## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
  RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
&& locale-gen en_US.utf8 \
&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
&& echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default

ENV R_BASE_VERSION 3.2.0

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
RUN apt-get update \
&& apt-get install -t unstable -y --no-install-recommends \
littler/unstable \
r-base=${R_BASE_VERSION}* \
r-base-dev=${R_BASE_VERSION}* \
r-recommended=${R_BASE_VERSION}* \
&& echo 'options(repos = list(CRAN = "http://cran.rstudio.com/"))' >> /etc/R/Rprofile.site \
&& echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
&& install.r docopt \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
&& rm -rf /var/lib/apt/lists/*
  
  CMD ["R"]