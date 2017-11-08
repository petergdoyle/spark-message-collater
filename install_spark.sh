#!/bin/sh
. ./common.sh

if [[ $EUID -ne 0 ]]; then
  display_error "This script must be run as root"
  exit 1
fi

spark='spark-2.2.0-bin-hadoop2.7'
spark_url="http://mirror.olnevhost.net/pub/apache/spark/spark-2.2.0/$spark.tgz"

if [ ! -d /usr/spark/$spark ]; then

  prompt="It appears $spark is not installed. Do you want to install it (y/n)? "
  default_value="y"
  read -e -p "$(echo -e $BOLD$YELLOW$prompt $cmd $RESET)" -i "$default_value" install_it
  if [ "$install_it" != 'y' ]; then
    exit 0
  fi

  if [ ! -f /usr/spark ]; then
    mkdir -pv /usr/spark
  fi

  curl -O $spark_url \
    && tar -xvf $spark.tgz -C /usr/spark \
    && ln -s /usr/spark/$spark /usr/spark/default \
    && rm -f $spark.tgz

  export SPARK_HOME=/usr/spark/default
  cat >/etc/profile.d/spark.sh <<-EOF
export SPARK_HOME=$SPARK_HOME
EOF

  # register all the java tools and executables to the OS as executables
  install_dir="$SPARK_HOME/bin"
  for each in $(find $install_dir -executable -type f) ; do
    name=$(basename $each)
    alternatives --install "/usr/bin/$name" "$name" "$each" 99999
  done

else
  display_info "spark-2 already installed"
fi
