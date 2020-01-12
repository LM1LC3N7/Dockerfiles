# Seedbox

A seedbox service allow to download torrent files on the server, and then download them directly to a local computer.
This service is composed in two part, one is the downloader application (rTorrent) and is other one is the web interface (flood).


## rTorrent

rTorrent is an open-source BitTorrent client available on [GitHub](https://github.com/rakshasa/rtorrent/).
Starting from version 0.9.7, `rtorrent` can be launch as a daemon, no more `screen` or `tmux`.

There is a web UI to control rTorrent, [jfurrow/flood](https://github.com/jfurrow/flood), also available as a Dockerfile in this project.


## Build

**rTorrent:**

* **Base image:** Alpine linux
* **`rtorrent` version:** Last version available on [edge testing alpine repository](http://dl-cdn.alpinelinux.org/alpine/edge/main)
* **Multi-stage:** No
* **Supervisor:** Yes, [`s6-overlay`](https://github.com/just-containers/s6-overlay#goals)


**flood:**

* **Base image:** Distroless
* **`flood` version:** Last version available on the GitHub project
* **Multi-stage:** Yes
* **Supervisor:** No


Command to build:

```bash
docker-compose build rtorrent
docker-compose build flood
```


## Image details

**rTorrent:**

* **Based on:** Alpine Linux
* **Layers:** 3
* **Size:** 32,6 Mio
* **Startup time:** 8 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes, with host
* **Hardware limitations:** 2 CPU, 1024 Mio RAM, no SWAP
* **Low privileges** yes, running using `rtorrent` user
* **Capabilities limitations:** `chown`, `fowner`, `setuid`, `dac_override`


**flood:**

* **Based on:** Distroless
* **Layers:** 6
* **Size:** 363 Mio
* **Startup time:** 10 seconds
* **Auto-restart:** yes
* **Time Synchronization** no
* **Hardware limitations:** 0.5 CPU, 150 Mio RAM, no SWAP
* **Low privileges** no
* **Capabilities limitations:** `dac_override`

Flood container is using the `proxy` network in order to contact the `traefik` container (a proxy service) and is also connected to `rtorrent-backend` (as rtorrent) to contact rTorrent service.


## Before starting

### 1. Import Secrets
Import all secrets stored as system variables into `SECRET.env` before starting the container.

`SECRET.env` example:

```bash
declare -x FLOOD_SECRET="long-random-password"
```

To import all secrets on the current bash:

```bash
. SECRET.env
```


### 2. Start all containers

Using `docker-compose up -d`:

```bash
$ . flood/SECRET.env
$ . rtorrent/SECRET.env
$ docker-compose up -d 
$ docker logs -f flood
Flood server starting on http://0.0.0.0:3000.
$ docker logs -f rtorrent
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] 02-rtorrent: applying...
[fix-attrs.d] 02-rtorrent: exited 0.
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] 01-rtorrent: executing...
[cont-init.d] 01-rtorrent: exited 0.
[cont-init.d] done.
[services.d] starting services
-----------------------------------------------
   _             _  _                     _
  | |           (_)| |                   | |
  | | _ __ ___   _ | |  ___   ___  _ __  | |_
  | || '_ \ _ \ | || | / __| / _ \| '_ \ | __|
  | || | | | | || || || (__ |  __/| | | || |_
  |_||_| |_| |_||_||_| \___| \___||_| |_| \__|

-----------------------------------------------
 Application : rtorrent
 Running user: rtorrent
 Base OS     : Alpine
-----------------------------------------------
 rTorrent configuration
   - Config file: /app/rtorrent/rtorrent.rc
   - Log file   : /app/rtorrent/s6-start.log
-----------------------------------------------
[*] Starting rtorrent
[services.d] done.
==> s6-start.log <==

==> log/execute.log <==

---
^@sh -c echo >/app/rtorrent/session/rtorrent.pid 325
---
^@
--- Success ---
^@
==> log/rtorrent-1578502389.log <==
1578502389 W Ignoring rtorrent.rc.
1578502389 N rtorrent scgi: Starting thread.
1578502389 N rtorrent main: Starting thread.
```
