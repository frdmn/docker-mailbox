docker-mailbox (WIP)
====================

Docker image that ships a running Nginx/PHP, Dovecot, Postfix as well as ViMbAdmin to configure and maintain the mail server.

(Note: this project is still a work in progress!)

### Requirements

* Either VirtualBox or Docker

### Installation

1. Clone GitHub repository  
  `git clone https://github.com/frdmn/docker-mailbox && cd docker-mailbox`
2. Copy the default settings, rename and adjust it:  
  `cp settings-example.conf settings.conf && editor settings.conf`
3. In case you use VirtualBox, run the `Vagrantfile` (if you don't, skip steps 3 - 7):  
  `vagrant up`
4. Patiently wait about 10 minutes until the base box is set up, the core packages are installed as well as Docker is set up: :coffee: :watch:  
5. SSH into the Vagrant box:  
  `vagrant ssh`
6. Make yourself a root (to bind listener to well known ports < 1024):  
  `sudo su`
7. Change into the project directory:  
  `cd /vagrant`
8. Build the Docker image using the `Makefile`:  
  `make`
9. Run the built image and set port mappings for IMAP, SMTP, HTTP and MySQL:  
    `make run`  
    \> [...]  
    \> 243891e844ed
10. To enter the container:  
  `docker-enter mailbox_ins`

## Version

0.0.1

### License

[WTFPL](LICENSE)
