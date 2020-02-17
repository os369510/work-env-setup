FROM ubuntu:bionic

MAINTAINER os369510@gmail.com

ENV Contact=os369510@gmail.com

LABEL Owner=os369510

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get install -y sudo devscripts debhelper dh-modaliases pbuilder && \
  rm -rf /var/lib/apt/lists/* \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*

ENTRYPOINT ["apt", "update"]
CMD ["bash"]
