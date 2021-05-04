# Build of my Ubuntu DevOps container with user devuser
# build via following command:
# docker build --rm -f Dockerfile -t ubuntu:john .
# When build is completed, start container via:
# docker run --rm -it -v 'pwd':/developer ubuntu:john

# Build from base image
FROM ubuntu:rolling

# Maintainer label
LABEL maintainer="John Derix <j.derix@johnderix.nl>"

# Set tzdata to Europe/Amsterdam
ENV TZ=Europe/Amsterdam

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install apps and tools I need
RUN apt-get update && apt-get install -y \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Install apps and devops tools I need
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    gnupg \
    nodejs \
    zsh \
    wget \
    nano \
    nodejs \
    npm \
    fonts-powerline

# Install extra tooling
RUN apt-get update && apt-get install -y \
    python3-pip \
    atop

# Install Ansible
RUN pip3 install ansible

# Add user devops to work with instead of root
RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser \
    && echo "devuser:<a href="mailto://p@ssword1">p@ssword1</a>" | chpasswd && usermod -aG sudo devuser

# Set Environment to use utf8
ENV LANG en_US.utf8

# Set theme
ADD scripts/installthemes.sh /home/devuser/installthemes.sh

USER devuser
ENV TERM xterm
ENV ZSH_THEME agnoster
CMD ["zsh"]

