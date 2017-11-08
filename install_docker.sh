#!/bin/sh
. ./common.sh

if [[ $EUID -ne 0 ]]; then
  display_error "This script must be run as root"
  exit 1
fi

eval 'docker --version' > /dev/null 2>&1
if [ $? -eq 127 ]; then

  prompt="It appears docker is not installed. Do you want to install it (y/n)? "
  default_value="y"
  read -e -p "$(echo -e $BOLD$YELLOW$prompt $cmd $RESET)" -i "$default_value" install_it
  if [ "$install_it" != 'y' ]; then
    exit 0
  fi

  yum -y remove docker docker-common  docker-selinux docker-engine
  yum -y install yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  rm -fr /etc/yum.repos.d/docker.repo
  yum-config-manager --enable docker-ce-edge
  yum-config-manager --enable docker-ce-test
  yum -y makecache fast
  yum -y install docker-ce

  systemctl start docker
  systemctl enable docker
  groupadd docker

  yum -y install python-pip
  pip install --upgrade pip
  pip install -U docker-compose

  usermod -aG docker vagrant

else
  display_info "docker and docker-compose already installed"
fi
