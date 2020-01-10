# Netdata

Netdata is distributed, real-time, performance and health monitoring for systems and applications. It is a highly optimized monitoring agent you install on all your systems and containers. This project is available on [GitHub](https://github.com/netdata/netdata/).


## Build

* **Base image:** Alpine linux
* **`netdata` version:** Last version available on [GitHub release](https://github.com/netdata/netdata/releases)
* **Multi-stage:** No
* **Supervisor:** Yes, [`s6-overlay`](https://github.com/just-containers/s6-overlay#goals)

Command:

```bash
docker-compose build netdata
```

## Image details

* **Based on:** Alpine Linux
* **Layers:** 4
* **Size:** 58,1 Mio
* **Startup time:** 10 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes, with host
* **Hardware limitations:** 1 CPU, 250 Mio RAM, no SWAP
* **Low privileges** yes, running using `netdata` user
* **Capabilities limitations:** `dac_override`, `SYS_PTRACE`

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service).


## Before starting
Before starting a new instance, the configuration should be updated in `SECRET.env` for access password (basic auth).

**SECRET.env**

```bash
# For Traefik
declare -x NETDATA_BASIC_AUTH="HASH"
```

Then import secrets to the local bash:

```bash
. SECRET.env
```


## Start

Using `docker-compose up -d`:

```bash
$ . SECRET.env
$ docker-compose up -d 
$ docker logs -f netdata
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] done.
[services.d] starting services
-----------------------------------------------
   _             _  _                     _
  | |           (_)| |                   | |
  | | _ __ ___     | |  ___   ___  _ __  | |_
  | || '_ \ _ \ | || | / __| / _ \| '_ \ | __|
  | || | | | | || || || (__ |  __/| | | || |_
  |_||_| |_| |_||_||_| \___| \___||_| |_| \__|

-----------------------------------------------
 Application : netdata
 Running user: app
 Base OS     : Alpine
-----------------------------------------------
 netdata configuration
   - Listen     : 0.0.0.0:19999
-----------------------------------------------

[*] Starting
[services.d] done.
2020-01-09 15:20:16: netdata INFO  : MAIN : Using host prefix directory '/host'
2020-01-09 15:20:16: netdata INFO  : MAIN : SIGNAL: Not enabling reaper
```
