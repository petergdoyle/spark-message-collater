
Vagrant.configure("2") do |config|

  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1511"

  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2
    vb.memory = "1024"
  end

  config.vm.hostname = "spark-message-collater.cleverfishsoftware.com"

  config.vm.provision "shell", inline: <<-SHELL

  yum -y install net-tools telnet wireshark htop bash-completion vim

  yum -y update

  SHELL
end
