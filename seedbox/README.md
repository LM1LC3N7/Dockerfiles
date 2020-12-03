# Seedbox

A seedbox service allow to download torrent files on the server, and then download them directly to a local computer.
This service is composed in two part, one is the downloader application (rTorrent) and is other one is the web interface (flood).


### rTorrent

rTorrent is an open-source BitTorrent client available on [GitHub](https://github.com/rakshasa/rtorrent/).
Starting from version 0.9.7, `rtorrent` can be launch as a daemon, no more `screen` or `tmux`.

There is a web UI to control rTorrent, [jfurrow/flood](https://github.com/jfurrow/flood), also available as a Dockerfile in this project.

### Flood
This is a web UI for rTorrent available on GitHub: [jfurrow/flood](https://github.com/jfurrow/flood).



## Build & Image details

**rTorrent:**

* **Base image:** Alpine linux
* **`rtorrent` version:** Last version available on [edge testing alpine repository](http://dl-cdn.alpinelinux.org/alpine/edge/main)
* **Supervisor:** Yes, [`s6-overlay`](https://github.com/just-containers/s6-overlay#goals)
* **Multi-stage:** No
* **Layers:** 3
* **Size:** 23,8 Mio
* **Startup time:** 8 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes, with host
* **Hardware limitations:** 2 CPU, 1024 Mio RAM, no SWAP, 50 pids max.
* **Low privileges** yes, running using `rtorrent` user.
* **Capabilities limitations:** `chown`, `fowner`, `setuid`, `dac_override`


**flood:**

* **Base image:** Distroless
* **`flood` version:** Last version available on the GitHub project
* **Supervisor:** Yes, [`s6-overlay`](https://github.com/just-containers/s6-overlay#goals)
* **Multi-stage:** Yes
* **Layers:** 7
* **Size:** 450 Mio
* **Startup time:** 10 seconds
* **Auto-restart:** yes
* **Time Synchronization** no
* **Hardware limitations:** 1 CPU, 256 Mio RAM, no SWAP, 50 pids max.
* **Low privileges** yes, running using `flood` user.
* **Capabilities limitations:** `chown`, `fowner`, `setuid`, `dac_override`



Command to build:

```bash
docker-compose build
```


## Before starting

Create the file `SECRET.env`, edit it and import it before starting a container.
Two example are present, `SECRET.env` for `bash` and `SECRET.fish.env` for `fish shell`.

```bash
$ cp SECRET.example SECRET.env
$ cat SECRET.env
declare -x FLOOD_SECRET="long-random-password"
$ . SECRET.env
$ docker-compose up -d
```



## Start all containers

Using `docker-compose up -d`:

```bash
$ . SECRET.env
$ docker-compose up -d 
```

```bash
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
sh -c echo >/app/rtorrent/session/rtorrent.pid 337
---

--- Success ---

==> log/rtorrent-.log <==
1607004082 W Ignoring rtorrent.rc.
1607004082 I listen port 49184 opened with backlog set to 128
1607004082 D could not open input history file (path:/app/rtorrent/session/rtorrent.input_history)
1607004082 N rtorrent main: Starting thread.
1607004082 N rtorrent scgi: Starting thread.
```


```bash
$ docker logs -f flood
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] 00-alpine-upgrade: executing...
[*] Upgrading Alpine.
[cont-init.d] 00-alpine-upgrade: exited 0.
[cont-init.d] 02-fix-ownership: executing...
[*] Fixing ownership.
[*] Fixing permissions.
[cont-init.d] 02-fix-ownership: exited 0.
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
 Application : flood
 Running user: flood
 Base OS     : Alpine
-----------------------------------------------
 Flood configuration
   - Installation path  : /app/flood
   - Running as user    : flood
   - UID & GID          : 9991
   - Configuration file : /app/flood/config.json
-----------------------------------------------
[*] Starting Flood
[services.d] done.
Flood server starting on http://0.0.0.0:3000.

```
