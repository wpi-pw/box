#!/usr/bin/env bash

echo "=============================="
echo "System update and packages cleanup"
echo "=============================="
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
sudo echo grub-pc hold | sudo dpkg --set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

echo "=============================="
echo "Install useful packages"
echo "=============================="
sudo apt install haveged curl git unzip zip -y

echo "=============================="
echo "Your username WordOps, your email is test@test.test"
echo "=============================="
sudo chown vagrant:vagrant /home/vagrant/.[^.]*
sudo echo -e "[user]\n\tname = WordOps\n\temail = test@test.test" > ~/.gitconfig

echo "=============================="
echo "Install WordOps"
echo "=============================="
sudo wget -qO wo wops.cc
sudo bash wo || exit 1
source /etc/bash_completion.d/wo_auto.rc

echo "=============================="
echo "Install Nginx, php7.3 and configure WO backend"
echo "=============================="
sudo wo stack install --php73 --mysql || exit 1
sudo yes | sudo wo site create 0.test --php73 --mysql
sudo echo -e "[user]\n\tname = WordOps\n\temail = test@test.test" > ~/.gitconfig
sudo yes | sudo wo site delete 0.test

echo "=============================="
echo "Install Composer"
echo "=============================="
cd ~/
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer

echo "=============================="
echo "Allow shell for www-data for SFTP usage"
echo "=============================="
sudo usermod -s /bin/bash www-data

echo "=============================="
echo "Wordmove installation"
echo "=============================="
if [ $(gem -v|grep '^2.') ]; then
	echo "gem installed"
else
	sudo apt-get install -y ruby-dev
	echo "ruby-dev installed"
	echo "gem not installed"
	sudo gem install rubygems-update
	sudo update_rubygems
fi
wordmove_install="$(gem list wordmove -i)"
if [ "$wordmove_install" = true ]; then
  echo "wordmove installed"
else
  echo "wordmove not installed"
  sudo gem install wordmove
  wordmove_path="$(gem which wordmove | sed -s 's/.rb/\/deployer\/base.rb/')"
  if [  "$(grep yaml $wordmove_path)" ]; then
    echo "can require yaml"
  else
    echo "can't require yaml"
    echo "set require yaml"
    sudo sed -i "7i require\ \'yaml\'" $wordmove_path
    echo "can require yaml"
  fi
fi

echo "=============================="
echo "wp cli - ianstall and add bash-completion for user www-data"
echo "=============================="
# automatically generate the security keys
wp package install aaemnnosttv/wp-cli-dotenv-command --allow-root
# download wp-cli bash_completion
sudo wget -O /etc/bash_completion.d/wp-completion.bash https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash
# change /var/www owner
sudo chown www-data:www-data /var/www
# download .profile & .bashrc for www-data
sudo wget -O /var/www/.profile https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/var/www/.profile
sudo wget -O /var/www/.bashrc https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/var/www/.bashrc

# set owner
sudo chown www-data:www-data /var/www/.profile
sudo chown www-data:www-data /var/www/.bashrc

echo "=============================="
echo "Downloading: search-replace-database installer - srdb.sh"
echo "=============================="
cd /usr/local/bin && sudo wget https://gist.githubusercontent.com/DimaMinka/24c3df57a78dd841a534666a233492a9/raw/d5ca7209164c7a22879fc7863f1bac1f0145ba84/srdb.sh
sudo chmod +x srdb.sh

echo "=============================="
echo "Clean before package"
echo "=============================="
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
sudo apt-get -y autoremove && sudo apt-get clean
export DEBIAN_FRONTEND=newt
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
sudo cat /dev/null > ~/.bash_history && history -c
