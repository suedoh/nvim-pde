#!/bin/bash
## Make Sure You Source lua/stakt/packer and sync first
#

mkdir -p ~/.config/nvim/after/plugin/

# Raw github base url
GIT_URL=https://raw.githubusercontent.com/suedoh/nvim-config/main
NVIM_CONFIG_DIR=~/.config/nvim
STAKT_CONFIG=${NVIM_CONFIG_DIR}/lua/stakt
AFTER_PLUGIN_DIR=${NVIM_CONFIG_DIR}/after/plugin

# Grab nvim lua configs
# Create a function for this hack
curl -L \
    ${GIT_URL}/lua/stakt/set.lua \
    >> ${STAKT_CONFIG}/set.lua

curl -L \
    ${GIT_URL}/lua/stakt/remap.lua \
    >> ${STAKT_CONFIG}/remap.lua

curl -L \
    ${GIT_URL}/init.lua \
    >> ${NVIM_CONFIG_DIR}/init.lua

curl -L \
    ${GIT_URL}/after/plugin/colors.lua \
    >> ${AFTER_PLUGIN_DIR}/colors.lua

curl -L \
    ${GIT_URL}/after/plugin/fugitive.lua \
    >> ${AFTER_PLUGIN_DIR}/fugitive.lua

curl -L \
    ${GIT_URL}/after/plugin/feline.lua \
    >> ${AFTER_PLUGIN_DIR}/feline.lua

# Configure git to checkout after/pliugin directory
git init
git remote add -f origin https://github.com/suedoh/nvim-config.github

git config core.sparseCheckout true

echo "after/plugin/" >> .git/info/sparse-checkout

git pull origin master
