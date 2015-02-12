# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Returns the number of processor for Linux, OS X or Windows.
def number_of_processors
  if RUBY_PLATFORM =~ /linux/
    return `cat /proc/cpuinfo | grep processor | wc -l`.to_i
  elsif RUBY_PLATFORM =~ /darwin/
    return `sysctl -n hw.logicalcpu`.to_i
  elsif RUBY_PLATFORM =~ /win32/
    # this works for windows 2000 or greater
    require 'win32ole'
    wmi = WIN32OLE.connect("winmgmts://")
    wmi.ExecQuery("select * from Win32_ComputerSystem").each do |system| 
      begin
        processors = system.NumberOfLogicalProcessors
      rescue
        processors = 0
      end
      return [system.NumberOfProcessors, processors].max
    end
  end
  raise "can't determine 'number_of_processors' for '#{RUBY_PLATFORM}'"
end

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
    config.vm.synced_folder line, "/data/#{dir}", type: "nfs"
  end
  f.close

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = number_of_processors()
  end
end
