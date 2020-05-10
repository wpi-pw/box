# Vagrant WordOps clean box for VagrantCloud package

========================

[WPI Cloud](https://cloud.wpi.pw) - [WordOps](https://wordops.net) - [Vagrant](https://vagrantup.com/) - [VagrantCloud](https://app.vagrantup.com/wpi/boxes/box)

A LEMP stack with WordOps, Ubuntu 16.04/18.04, vagrant, nginx, apache, php-5-7.4, php-fpm, MariaDB 10.3, git, composer, wp-cli and more.

## Init commands for custom box preparing
```shell script
$ vagrant box update --box=bento/ubuntu-18.04
$ vagrant up
$ vagrant box remove wpi/box
$ vagrant package --output wpi.box
$ vagrant box add wpi/box wpi.box
$ vagrant destroy
$ rm wpi.box
```
