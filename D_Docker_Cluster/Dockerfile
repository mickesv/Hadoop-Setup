FROM ubuntu:latest
MAINTAINER Mikael Svahnberg "Mikael.Svahnberg@bth.se"

# Basic
# ----------
RUN apt-get -y -q update
RUN apt-get -y -q install wget git-core

# Puppet
# ----------
RUN apt-get -y -q install rubygems
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install puppet

ADD modules /
ADD manifest /
