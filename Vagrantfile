# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.59.104"
  #config.vm.network :forwarded_port, guest: 2375, host: 2375
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.synced_folder '.', '/vagrant', disabled: true
  f = File.open("syncdirs", "r")
  f.each_line do |line|
    line = line.strip
    dir = line.split('/')[-1]
    config.vm.synced_folder line, "/data/#{dir}", type: "rsync"
  end
  f.close

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 8
  end
end
