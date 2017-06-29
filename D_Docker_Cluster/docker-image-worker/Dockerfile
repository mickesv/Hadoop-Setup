FROM msv/docker-hadoop-base
MAINTAINER Mikael Svahnberg "Mikael.Svahnberg@bth.se"

RUN apt-get -qq install lsb-release >/dev/null

RUN puppet module install puppetlabs-java --version 2.1.0 \
    --modulepath=/modules

RUN puppet apply \
    --verbose \
#    --debug \
    --modulepath=/modules \
    --certname=default \
    /manifests/base-hadoop.pp

ADD worker-start.sh /worker-start.sh

ENTRYPOINT ["/worker-start.sh"]
