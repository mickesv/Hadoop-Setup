FROM msv/docker-hadoop-base
MAINTAINER Mikael Svahnberg "Mikael.Svahnberg@bth.se"

RUN apt-get -qq install lsb-release >/dev/null

RUN puppet module install puppetlabs-java --version 2.1.0 \
    --modulepath=/modules

RUN puppet apply \
    --verbose \
#    --debug \
    --modulepath=/modules \
    --certname=master \
    /manifests/base-hadoop.pp


# Slow as molass, since each open port means a spawned thread. Obviously won't work.
# EXPOSE 1004 8020 8030 8031 8032 8040 8041 8042 8088 9000 50010 50020 50070 50075 20000-49999

# 50070 web interface for hdfs
# 8088  web interface for yarn
# 9000  hdfs access
EXPOSE 50070 8088 9000



ADD hadoop-start.sh /hadoop-start.sh

ENTRYPOINT ["/hadoop-start.sh"]
