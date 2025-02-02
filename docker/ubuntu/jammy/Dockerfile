FROM ubuntu:jammy

MAINTAINER os369510@gmail.com

ENV User=ubuntu
ENV Contact=os369510@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

LABEL Owner=os369510

USER root

RUN \
  echo "tzdata tzdata/Zones/Asia select Taipei" >> /tmp/preseed.txt; \
  debconf-set-selections /tmp/preseed.txt && \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y apt-utils build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget cscope && \
  apt-get install -y sudo devscripts debhelper dh-modaliases pbuilder && \
  apt-get install -y systemd tree python3-distro-info snapd && \
  apt-get install -y python3-pip python3-setuptools python3-wget && \
  apt-get install -y sshpass universal-ctags rclone && \
  apt-get install -y ubuntu-dev-tools ca-certificates iputils-ping && \
  apt-get install -y git-buildpackage

RUN \
  rm -rf /var/lib/apt/lists/* \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*

RUN useradd -ms /bin/bash ${User} && echo "${User}:${User}" | chpasswd && adduser ${User} sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudo

USER ${User}

CMD ["bash"]
