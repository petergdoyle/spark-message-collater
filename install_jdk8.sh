#!/bin/sh
. ./common.sh

if [[ $EUID -ne 0 ]]; then
  display_error "This script must be run as root"
  exit 1
fi

java='java-1.8.0-openjdk'

java -version > /dev/null 2>&1
if [ $? -eq 127 ]; then

  prompt="It appears $java is not installed. Do you want to install it (y/n)? "
  default_value="y"
  read -e -p "$(echo -e $BOLD$YELLOW$prompt $cmd $RESET)" -i "$default_value" install_it
  if [ "$install_it" != 'y' ]; then
    exit 0
  fi

  if [ ! -f /usr/java ]; then
    mkdir -pv /usr/java
  fi

  yum install -y "$java"*
  java_home=`alternatives --list |grep jre_1.8.0_openjdk| awk '{print $3}'`
  ln -s "$java_home" /usr/java/default
  export JAVA_HOME=/usr/java/default
  cat >/etc/profile.d/java.sh <<-EOF
export JAVA_HOME=$JAVA_HOME
EOF

  # register all the java tools and executables to the OS as executables
  install_dir="$JAVA_HOME/bin"
  for each in $(find $install_dir -executable -type f) ; do
    name=$(basename $each)
    alternatives --install "/usr/bin/$name" "$name" "$each" 99999
  done

else
  display_info "$java already installed"
fi
