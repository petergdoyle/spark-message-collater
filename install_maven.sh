#!/bin/sh
. ./common.sh

if [[ $EUID -ne 0 ]]; then
  display_error "This script must be run as root"
  exit 1
fi

maven='apache-maven-3.3.9'
maven_url="http://www-us.apache.org/dist/maven/maven-3/3.3.9/binaries/$maven-bin.tar.gz"

eval 'mvn -version' > /dev/null 2>&1
if [ $? -eq 127 ]; then

  prompt="It appears $maven is not installed. Do you want to install it (y/n)? "
  default_value="y"
  read -e -p "$(echo -e $BOLD$YELLOW$prompt $cmd $RESET)" -i "$default_value" install_it
  if [ "$install_it" != 'y' ]; then
    exit 0
  fi

  if [ ! -f /usr/spark ]; then
    mkdir -pv /usr/spark
  fi

  #install maven
  curl -O $maven_url \
    && tar -xvf $maven-bin.tar.gz -C /usr/maven \
    && ln -s /usr/maven/$maven /usr/maven/default \
    && rm -f $maven-bin.tar.gz
  alternatives --install "/usr/bin/mvn" "mvn" "/usr/maven/default/bin/mvn" 99999
  export MAVEN_HOME=/usr/maven/default
  cat >/etc/profile.d/maven.sh <<-EOF
export MAVEN_HOME=$MAVEN_HOME
EOF

else
  display_info "apache-maven-3 already installed"
fi
