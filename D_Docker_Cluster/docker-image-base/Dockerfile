FROM ubuntu:xenial
MAINTAINER Mikael Svahnberg "Mikael.Svahnberg@bth.se"

# Basic
# ----------
RUN apt-get -qq update
RUN apt-get -qq install wget git-core > /dev/null

# Puppet
# ----------
RUN apt-get -qq install rubygems > /dev/null
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install puppet

ADD modules /modules
ADD manifests /manifests
