#!/bin/sh -eux
# install git flow (avh edition) extensions to git.

# install git-flow binaries from source. ---------------------------------------
# create git-flow source parent folder.
mkdir -p /usr/local/src/git
cd /usr/local/src/git

# retrieve git-flow installer from github.com.
wget --no-verbose --no-check-certificate https://github.com/petervanderdoes/gitflow-avh/raw/develop/contrib/gitflow-installer.sh
chmod 755 gitflow-installer.sh

# create git-flow binary parent folder.
mkdir -p /usr/local/git/gitflow/bin

# build and install git-flow binaries.
PREFIX=/usr/local/git/gitflow
export PREFIX

./gitflow-installer.sh install stable

# set git-flow home environment variables.
GIT_FLOW_HOME=/usr/local/git/gitflow
export GIT_FLOW_HOME
PATH=${GIT_FLOW_HOME}/bin:$PATH
export PATH

# verify installation.
git flow version

# install git-flow completion for bash. ----------------------------------------
gfcbin=".git-flow-completion.bash"
gfcfolder="/home/vagrant"

# download git-flow completion for bash from github.com.
curl --silent --location "https://raw.githubusercontent.com/petervanderdoes/git-flow-completion/develop/git-flow-completion.bash" --output ${gfcfolder}/${gfcbin}
chown -R vagrant:vagrant ${gfcfolder}/${gfcbin}
chmod 644 ${gfcfolder}/${gfcbin}
