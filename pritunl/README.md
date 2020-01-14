# Pritunl

[Pritunl](https://github.com/pritunl/pritunl) is a distributed enterprise vpn server built using the OpenVPN protocol.
Basically, I use it as a web interface to create openvpn local servers and users.

## Build

* **Base image:** Alpine
* **Pritunl version:** Last version available on the GitHub project
* **Multi-stage:** No
* **Supervisor:** No

Command:

```bash
docker-compose build
```


## Image details
### Pritunl ###

* **Based on:** Alpine
* **Layers:** 4
* **Size:** 719 Mio
* **Startup time:** 20 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes
* **Hardware limitations:** 1 CPU, 512 Mio RAM, no SWAP
* **Low privileges** no
* **Capabilities limitations:** yes

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service) and is also connected to `pritunl-backend` to contact the database.


### Mongo ###

Official image used from hub.docker.com.


## Before starting

**pritunl.env**

```bash
REVERSE_PROXY=true
```


## Start

Using `docker-compose up -d`:

```bash
$ docker-compose up -d 
$ docker logs -f pritunl
Creating pritunl-db ... done
Creating pritunl    ... done
2020-01-14T17:20:08.516 <docker-entrypoint> INFO - Script version 1.0.1
2020-01-14T17:20:08.520 <docker-entrypoint> INFO - Insuring pritunl setup for container
Database configuration successfully set
app.server_protocol = "ipv4"
Successfully updated configuration. This change is stored in the database and has been applied to all hosts in the cluster.
app.reverse_proxy = true
Successfully updated configuration. This change is stored in the database and has been applied to all hosts in the cluster.
app.server_ssl = true
Successfully updated configuration. This change is stored in the database and has been applied to all hosts in the cluster.
app.server_port = 9700
Successfully updated configuration. This change is stored in the database and has been applied to all hosts in the cluster.
2020-01-14T17:20:21.072 <docker-entrypoint> EXEC - /usr/bin/pritunl start
##############################################################
#                                                            #
#                      /$$   /$$                         /$$ #
#                     |__/  | $$                        | $$ #
#   /$$$$$$   /$$$$$$  /$$ /$$$$$$   /$$   /$$ /$$$$$$$ | $$ #
#  /$$__  $$ /$$__  $$| $$|_  $$_/  | $$  | $$| $$__  $$| $$ #
# | $$  \ $$| $$  \__/| $$  | $$    | $$  | $$| $$  \ $$| $$ #
# | $$  | $$| $$      | $$  | $$ /$$| $$  | $$| $$  | $$| $$ #
# | $$$$$$$/| $$      | $$  |  $$$$/|  $$$$$$/| $$  | $$| $$ #
# | $$____/ |__/      |__/   \____/  \______/ |__/  |__/|__/ #
# | $$                                                       #
# | $$                                                       #
# |__/                                                       #
#                                                            #
##############################################################
[patient-waves-3202][2020-01-14 17:20:26,743][INFO] Starting server
  selinux_context = "none"
```

To get first login password, execute:

```bash
docker exec -ti pritunl pritunl default-password
```
