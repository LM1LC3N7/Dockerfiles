# Nextcloud

Private and self-hosted cloud.


## Build

* **Base image:** Linux server official image
* **Nextcloud version:** Last version available on hub.docker.com
* **Multi-stage:** No
* **Supervisor:** No


## Image details
### Nextcloud ###

* **Based on:** linuxserver official image
* **Layers:** 7
* **Size:** 319 Mio
* **Startup time:** 05 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes
* **Hardware limitations:** 4 CPU, 1024 Mio RAM, no SWAP
* **Low privileges** yes
* **Capabilities limitations:** yes

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service) and is also connected to `nextcloud-backend` to contact the database.


### MariaDB ###

Official image used from hub.docker.com.



## Before starting

**default.env**

```bash
PUID=1000
PGID=1000
TZ=Europe/Paris
```

**SECRET.env**

```bash
# Nextcloud
declare -x NEXTCLOUD_DB_NAME="db-name"
declare -x NEXTCLOUD_ADMIN_USER="admin-user"
declare -x NEXTCLOUD_ADMIN_PASSWORD="admin-password"
# DB
declare -x NEXTCLOUD_MYSQL_DATABASE="db-name"
declare -x NEXTCLOUD_MYSQL_ROOT_PASSWORD="root-password"
declare -x NEXTCLOUD_MYSQL_USER="nextcloud"
declare -x NEXTCLOUD_MYSQL_PASSWORD="password-to-change"
```


## Start

Using `docker-compose up -d`:

```bash
$ docker-compose up -d 
$ docker logs -f nextcloud
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] 01-envfile: executing...
[cont-init.d] 01-envfile: exited 0.
[cont-init.d] 10-adduser: executing...

-------------------------------------
          _         ()
         | |  ___   _    __
         | | / __| | |  /  \
         | | \__ \ | | | () |
         |_| |___/ |_|  \__/


Brought to you by linuxserver.io
We gratefully accept donations at:
https://www.linuxserver.io/donate/
-------------------------------------
GID/UID
-------------------------------------

User uid:    1000
User gid:    1000
-------------------------------------

[cont-init.d] 10-adduser: exited 0.
[cont-init.d] 20-config: executing...
[cont-init.d] 20-config: exited 0.
[cont-init.d] 30-keygen: executing...
using keys found in /config/keys
[cont-init.d] 30-keygen: exited 0.
[cont-init.d] 40-config: executing...
[cont-init.d] 40-config: exited 0.
[cont-init.d] 50-install: executing...
[cont-init.d] 50-install: exited 0.
[cont-init.d] 60-memcache: executing...
[cont-init.d] 60-memcache: exited 0.
[cont-init.d] 99-custom-files: executing...
[custom-init] no custom files found exiting...
[cont-init.d] 99-custom-files: exited 0.
[cont-init.d] done.
[services.d] starting services
[services.d] done.
```

