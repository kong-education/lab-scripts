#!/bin/bash
# stops script on first error
# set -e

mkdir -p ~/.local/bin
# export variables
export PONGO_WD=/srv/shared/kong-plugin
export KONG_VERSION=2.6.0.0
export KONG_IMAGE=kong/kong-gateway:2.6.0.0-alpine
export POSTGRES=9.6
export PATH=~/.local/bin/:$PATH
export KONG_LICENSE_DATA=$(cat /etc/kong/license.json | tr -d '[:space:]')

git clone https://github.com/Kong/kong-pongo.git

# set symlink
ln -s $(realpath kong-pongo/pongo.sh) ~/.local/bin/pongo

# clone the kong-plugin folder in the shared volume. Here We want the sub-directory kong-plugin
cd /srv/shared
git init 
git remote add -f origin https://github.com/kong-education/kong-custom-plugin.git
git config core.sparseCheckout true
echo 'kong-plugin'  >> .git/info/sparse-checkout
git pull origin master

# run Pongo
cd /srv/shared/kong-plugin
pongo run 