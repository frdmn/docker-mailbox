docker-mailbox (WIP)
====================

Docker image that ships a running Nginx/PHP, Dovecot, Postfix as well as ViMbAdmin to configure and maintain the mail server.

(Note: this project is still a work in progress!)

### Requirements

* Docker

### Installation

1. Clone GitHub repository  
  `git clone https://github.com/frdmn/docker-mailbox && cd docker-mailbox`
2. Copy the default settings, rename and adjust it:  
  `cp settings-example.conf settings.conf && editor settings.conf`
3. Install boot2docker if you are on OS X:  
  http://boot2docker.io/
4. Build the Docker image using the `Makefile`:  
  `make`
5. Run the built image and set port mappings for IMAP, SMTP, HTTP and MySQL:  
    `make run`  
    \> [...]  
    \> 243891e844ed
6. To enter the container:  
  `docker-enter mailbox_ins`

## Version

0.0.1

### License

[WTFPL](LICENSE)
