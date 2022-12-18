# Setup Stage - set up the ZSH environment for optimal developer experience
FROM node:14-alpine AS setup

# Let scripts know we're running in Docker (useful for containerised development)
ENV RUNNING_IN_DOCKER true

# Use the unprivileged `node` user (pre-created by the Node image) for safety (and because it has permission to install modules)
RUN mkdir -p /usr/src/app \
          && chown -R node:node /usr/src/app

# Set up ZSH and our preferred terminal environment for containers
RUN apk --no-cache add zsh curl wget git build-base neovim

# Create directories for nvim config and antigen
RUN mkdir -p ~/.config/nvim
RUN mkdir -p /home/node/.antigen

# GET antigen and nvim init 
RUN curl -L git.io/antigen > /home/node/.antigen/antigen.zsh
RUN curl -L https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua > ~/.config/nvim/init.lua

# Use my starter Docker ZSH config file for this, or your own ZSH configuration file (https://gist.github.com/arctic-hen7/bbfcc3021f7592d2013ee70470fee60b)
COPY .dockershell.sh /home/node/.zshrc
RUN chown -R node:node /home/node/.antigen /home/node/.zshrc

# Set up ZSH as the unprivileged user (we just need to start it, it'll initialise our setup itself)
USER node
RUN /bin/zsh /home/node/.zshrc

# Switch back to root for whatever else we're doing
USER root
