Автоматизация telegram-bot по продаже dedicate server и virtual machine.

Чтобы ручками устанавивать зависимости, os, cloud-init и тд, я написал этот проект по автоматизации этого продукта(https://github.com/lookatme777/win-shop). 

В кратце: для поддержания магазина по продаже vm и dedicate server мне понадобится: код магазина(Bot), база данных(postgresql) для сохранения информации о конфигах машин, чеках и тп., ci/cd(jenkins) – для удобного update и тестов, firewall(OPNsesene) для проброса портов и создания правил, fog-project для автоматизация развёртывания os на удалённые сервера. 

 нам необходим HyperVisor, в нашем случае – Proxmox, чтобы создать несколько LXC(Jenkins, Bot, Postgresql, Nginx) и VM(Control-Node, OPNsense, FOG-Project). Каждая машина отвечает за своё: 

Архитектура: 
- Proxmox 
-- Control-Node (Ansible, Terraform, Packer)
-- Jenkins LXC
-- Bot LXC
-- Postgresql LXC
-- Nginx LXC
-- OPNsense 
-- FOG-project

Необходимо подключиться к Proxmox, установить необходимые OS для LXC и VM(Control-Node, OS для развёртывания)

1) Подключение к Proxmox -> Установка ubuntu-24.04.4-live-server-amd64(control-Node, deployment)

2) Установка debian-13-standard_13.1-2_amd64.tar.zst для LXC

3) 