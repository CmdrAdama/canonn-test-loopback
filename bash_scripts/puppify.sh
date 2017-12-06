#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

PUPPET_BIN=/opt/puppetlabs/puppet/bin
PUPPET_ENV=/etc/puppetlabs/code/environments

which wget > /dev/null 2>&1
WGET_CHECK=$?

which git > /dev/null 2>&1
GIT_CHECK=$?

test -f ${PUPPET_BIN}/puppet
PUPPET_CHECK=$?

if [ ${WGET_CHECK} == "1" ] || [ ${GIT_CHECK} == "1" ] || [ ${PUPPET_CHECK} == "1" ]; then
  echo "Initial apt-get update..."
  apt-get update >/dev/null
fi

if [ ${WGET_CHECK} == "1" ]; then
  echo "Installing wget..."
  apt-get --yes install wget >/dev/null
  echo "Wget installed."
fi

if [ ${GIT_CHECK} == "1" ]; then
  echo "Installing git..."
  apt-get --yes install git >/dev/null
  echo "Git installed."
fi

if [ ${PUPPET_CHECK} == "1" ]; then
  echo "Configuring PuppetLabs repo..."

  source /etc/lsb-release
  apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet >/dev/null

  TMP_DEB=$(mktemp)
  wget --output-document=${TMP_DEB} http://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb 2>/dev/null
  dpkg -i ${TMP_DEB} >/dev/null
  apt-get update >/dev/null

  echo "Installing puppet..."
  apt-get --yes install puppet-agent >/dev/null
  unlink ${TMP_DEB}
  echo "Puppet installed."
fi

if [ ! -d ${PUPPET_ENV}/production.orig ]; then
  mv ${PUPPET_ENV}/production ${PUPPET_ENV}/production.orig
fi
