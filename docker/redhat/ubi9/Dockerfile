# Use the official Red Hat Universal Base Image (UBI) as the base image
FROM registry.access.redhat.com/ubi9

# Maintainer information
LABEL maintainer="os369510@gmail.com"

# Set environment variables
ENV User=redhat
ENV Contact=os369510@gmail.com

# Update the system and install necessary packages
RUN yum update -y && \
    yum install -y \
        git sshpass sudo iputils vim \
        rpm-build make dracut

# Create a user and add to sudo group
RUN useradd -m -s /bin/bash ${User} && \
    echo "${User}:${User}" | chpasswd && \
    usermod -aG wheel ${User}

# Allow members of the wheel group to execute any command without a
# password prompt
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

USER ${User}

# Set the default command to bash
CMD ["bash"]

