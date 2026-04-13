#!/bin/bash

# Установка
sudo apt install docker.io docker-compose

# Установка python/venv/pip
sudo apt update
sudo apt upgrade
sudo apt install -y python3 python3-venv python3-pip

# Установка Ansible
sudo apt install -y ansible

# PACKER
sudo docker pull hashicorp/packer
# JENKINS
sudo sudo docker pull jenkins/jenkins
# NGINX
sudo docker pull nginx
# TERRAFORM
sudo docker pull hashicorp/terraform
# POSTGRESQL
sudo docker pull postgres

