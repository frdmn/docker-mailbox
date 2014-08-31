# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$aptPkgScript = <<SCRIPT
apt-get update 
apt-get install -y docker.io git
apt-get purge -y puppet puppet-common
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade -y
apt-get autoremove-y 
ln -sf /usr/bin/docker.io /usr/local/bin/docker
sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3000, host: 8030
  config.vm.network :forwarded_port, guest: 3001, host: 8031
  config.vm.network :forwarded_port, guest: 3002, host: 8032
  config.vm.synced_folder ".", "/docker"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  config.vm.provision "shell", inline: $aptPkgScript
  # config.vm.provision "docker" do |d|
  #   d.build_image "/vagrant"
  # end
end
