# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$aptPkgScript = <<SCRIPT
apt-get update
apt-get purge -y puppet puppet-common
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade -y
apt-get autoremove -y
curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo apt-get install lxc-docker
sudo docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 143, host: 143
  config.vm.network :forwarded_port, guest: 587, host: 587
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  config.vm.provision "shell", inline: $aptPkgScript
end
