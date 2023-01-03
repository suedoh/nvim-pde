# Setup Stage - set up the ZSH environment for optimal developer experience
FROM alpine:latest AS setup

# Let scripts know we're running in Docker (useful for containerised development)
ENV RUNNING_IN_DOCKER true

# Set Work Directory and copy dependencies
WORKDIR /usr/src/app

# Add container dependencies
RUN apk add --no-cache \
    cmake \
    automake \
    autoconf \
    libtool \
    pkgconf \
    coreutils \
    unzip \
    gettext-tiny-dev \
    zsh \
    curl \
    wget \
    git \
    build-base \
    npm \
    go \
    neovim 

# Install AWS CLI
RUN apk --no-cache add \
    python3 \
    py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
    awscli \
    && rm -rf /var/cache/apk/*

# GET antigen for zshrc plugins
RUN mkdir -p /root/.antigen
RUN curl -L git.io/antigen > /root/.antigen/antigen.zsh

# Create directory for nvim provisioning
RUN mkdir -p /root/.config/nvim/lua/stakt

# Copy Config Files
COPY .dockershell.sh /root/.zshrc
COPY .nvim-provision.sh /root/.config/nvim

# Shell into zshrc
RUN /bin/zsh /root/.zshrc

# Switch back to root for whatever else needed
USER root

# Install Packer and GET base packer file
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

RUN curl -L \
 https://raw.githubusercontent.com/suedoh/nvim-config/main/lua/stakt/packer.lua \
 >> /root/.config/nvim/lua/stakt/packer.lua
