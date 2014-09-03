# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  config.vm.provision "docker" do |d|
    d.build_image "/vagrant", args: "-t frdmn/mailbox"
    d.run "frdmn/mailbox", args: "-p 2222:22 -p 3306:3306 -p 25:25 -p 80:80"
  end
end
