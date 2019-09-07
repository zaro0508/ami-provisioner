#!/bin/bash -e

main() {
 echo "install packages"
 export DEBIAN_FRONTEND=noninteractive
 sudo apt-get update
 # Install weechat hangs due to libssl update causing an interactive prompt
 # https://bugs.launchpad.net/ubuntu/+source/ansible/+bug/1833013
 # sudo apt-get install -y weechat-curses weechat-plugins
}

main
