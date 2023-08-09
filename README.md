# V-Profile JAVA Application on Vagrant

This repository contains the code and instructions for deploying a JAVA Application (vProfile)  on a Server using Vagrant. This infrastructure consists of 5 servers: a caching server (memcache), a database (mariadb), a message broker (rabbitmq), a web server (tomcat) and a reverse proxy (nginx).

## Task Overview

The task involves successfully setting up the stack using Vagrant.

## Layout

The infrastructure layout consists of the following:

1. memcache caching server (mc02).
2. mariadb database (db02).
3. rabbitmq message broker (rmq02)
4. Tomcat Web Server (app02)
5. Nginx Reverse Proxy (web02)

## Technologies Used

- Mysql ( Ver 15.1 Distrib 10.3.38-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2)
- Rabbitmq (3.12.2)
- Git (version 2.25.1)
- Java
  - openjdk version "11.0.20" 2023-07-18
  - OpenJDK Runtime Environment (build 11.0.20+8-post-Ubuntu-1ubuntu120.04)
  - OpenJDK 64-Bit Server VM (build 11.0.20+8-post-Ubuntu-1ubuntu120.04, mixed mode, sharing)
- Memcache
- Virtual box
  - VM box: "ubuntu/focal64"
  - Version: 6.1.38_Ubuntur153438
- Machine (Ubuntu 22.04)
- Vagrant host manager plugin

### Infrastructure as Code (IAC)

- Vagrant 2.2.19

## Installation

- Clone this Repo. ensure that all prerequisites are installed
- create a variables.env file and add the following data. `Your variable values can be any figure of your choice*`

```script
jdbcUsername=<your-mariadb-database-username>
jdbcPassword=<your-mariadb-database-password>
rabbitmqUsername=<your-rabbitmq-username>
rabbitmqPassword=<your-rabbitmq-password>
```

```bash
vagrant up
```

- Ensure that your env where updated correctly

``````bash
vagrant ssh app02
cat ~/vprofile-project/src/main/resources/application.properties
``````

`N/B: Ensure that you check the variable files for values specific to your deployments if any*`

Feel free to customize the scripts if you require different configurations for setup. **Ensure that the scripts have the appropriate permissions and are run with sudo as they involve installations.**

### Application URL

You can access the Java application at the following URL: <http://http://192.168.56.2//> after deployment and if IPs are not changed

## Modifications

### The following Modifications where considered

1. Making the deployment fully automated using bash scripts
2. making variable files to accommodate  variables

### Improvemnts

1. Make IPs and host naming variadic.
2. Copy files instead of cloning to speed up processes.
