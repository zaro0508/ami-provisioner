#!/bin/bash -e

main() {
  echo "install packages"
  sudo apt-get update
  # Install weechat hangs due to libssl update causing an interactive prompt
  # https://bugs.launchpad.net/ubuntu/+source/ansible/+bug/1833013
  # use work around from https://github.com/hashicorp/vagrant/issues/10914
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y weechat-curses weechat-plugins
}

main
