FROM msv/docker-hadoop-base
MAINTAINER Mikael Svahnberg "Mikael.Svahnberg@bth.se"

RUN puppet apply --verbose \
    --modulepath=/modules \
    --manifestdir=/manifests \
    --certname=master \
    /manifests/base-hadoop.pp


EXPOSE 8088 50070

ENTRYPOINT ["hadoop-start.sh"]
