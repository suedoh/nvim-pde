# Setup Stage - set up the ZSH environment for optimal developer experience
FROM node:14-alpine AS setup

# Let scripts know we're running in Docker (useful for containerised development)
ENV RUNNING_IN_DOCKER true

# Use the unprivileged `node` user (pre-created by the Node image) for safety (and because it has permission to install modules)
RUN mkdir -p /usr/src/app \
      && chown -R node:node /usr/src/app

# Set Work Directory and copy dependencies
WORKDIR /usr/src/app

# Set up ZSH and our preferred terminal environment for containers
RUN apk --no-cache add cmake automake autoconf libtool pkgconf coreutils unzip gettext-tiny-dev
RUN apk --no-cache add zsh curl wget git build-base npm go neovim

# Install AWS CLI
RUN apk add --no-cache \
    python3 \
    py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
    awscli \
    && rm -rf /var/cache/apk/*

RUN aws --version

# Create directories for nvim config and antigen
RUN mkdir -p ~/.config/nvim
RUN mkdir -p /root/.antigen

# GET antigen and nvim init 
RUN curl -L git.io/antigen > /root/.antigen/antigen.zsh
RUN curl -L https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua > ~/.config/nvim/init.lua

# Baseline zshrc for alpine usage and antigen to manage oh-my-zsh packages
COPY .dockershell.sh /root/.zshrc
RUN chown -R node:node /root/.antigen /root/.zshrc

# RUN cat /root/.zshrc
RUN /bin/zsh /root/.zshrc

# Set up ZSH as the unprivileged user (we just need to start it, it'll initialise our setup itself)
#USER node
#RUN /bin/zsh /root/.zshrc

# Switch back to root for whatever else needed
USER root

# Install serveless and bootstrap the app
RUN npm install serverless -g
RUN serverless create --template aws-nodejs

# Install Dependencies
RUN npm install
