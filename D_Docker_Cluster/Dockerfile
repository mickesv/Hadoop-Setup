FROM ubuntu:latest
MAINTAINER Mikael Svahnberg "Mikael.Svahnberg@bth.se"

# Basic
# ----------
RUN apt-get -qq update
RUN apt-get -qy install wget git-core

# Puppet
# ----------
RUN apt-get -qy install rubygems
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install puppet

ADD modules /
ADD manifest /
