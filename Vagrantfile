Vagrant.configure(2) do |config|
  config.vm.box = "trusty-amd64-vagrant"
  config.vm.synced_folder ".", "/docker"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3306, host: 8036
  config.vm.network :forwarded_port, guest: 25, host: 8025
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  config.vm.provider "docker" do |d|
    d.build_dir = "."
  end
end