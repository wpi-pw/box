Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.provision "shell", inline: "bash <(curl -s -L wpi.pw/bin/vagrant/box.sh)"
end
