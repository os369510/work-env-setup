# Use the official SUSE Linux Enterprise Server (SLES) as the base image
FROM registry.suse.com/bci/bci-base

# Maintainer information
LABEL maintainer="os369510@gmail.com"

# Set environment variables
ENV User=suse
ENV Contact=os369510@gmail.com

# Update the system and install necessary packages
RUN zypper --non-interactive update && \
    zypper --non-interactive install \
        git \
        sudo \
        iputils

# Create a user and add to sudo group
RUN useradd -m -s /bin/bash ${User} && \
    echo "${User}:${User}" | chpasswd
#    usermod -aG wheelusers ${User}

# Allow to execute any command without a password prompt
RUN echo "${User} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${User}

USER ${User}

# Set the default command to bash
CMD ["bash"]

