Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "hadoop"
    vb.cpus = 2
    vb.memory = "2048"
  end

  # vagrant-cachier speeds up provisioning by caching downloaded Linux packages.
  # To install, run `vagrant plugin install vagrant-cachier`.
  # See http://fgrehm.viewdocs.io/vagrant-cachier/.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provision "shell", path: "provision.sh"
end
