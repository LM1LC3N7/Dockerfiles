# Jellyfin

The Free Software Media System https://jellyfin.org
[Jellyfin](https://github.com/jellyfin/jellyfin) is a Free Software Media System that puts you in control of managing and streaming your media. It is an alternative to the proprietary Emby and Plex, to provide media from a dedicated server to end-user devices via multiple apps. Jellyfin is descended from Emby's 3.5.2 release and ported to the .NET Core framework to enable full cross-platform support. There are no strings attached, no premium licenses or features, and no hidden agendas: just a team who want to build something better and work together to achieve it. We welcome anyone who is interested in joining us in our quest!

**WORK IN PROGRESS :** This image is not custom, only the official one for now.


## Build

* **Base image:** Official Jellyfin image
* **Jellyfin version:** Last version available on hub.docker.com
* **Multi-stage:** No
* **Supervisor:** No

Command:

```bash
docker-compose build jellyfin
```


## Image details

* **Based on:** Official
* **Layers:** 8
* **Size:** 601 Mio
* **Startup time:** 5 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes
* **Hardware limitations:** 4 CPU, 2048 Mio RAM, no SWAP
* **Low privileges** To check
* **Capabilities limitations:** None

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service).



## Start

Using `docker-compose up -d`:

```bash
$ docker-compose up -d 
$ docker logs -f jellyfin
[16:26:31] [INF] Jellyfin version: 10.4.3
[16:26:31] [INF] Arguments: ["/jellyfin/jellyfin.dll", "--datadir", "/config", "--cachedir", "/cache", "--ffmpeg", "/usr/local/bin/ffmpeg"]
[16:26:31] [INF] Operating system: Linux
[16:26:31] [INF] Architecture: X64
[16:26:31] [INF] 64-Bit Process: True
[16:26:31] [INF] User Interactive: True
[16:26:31] [INF] Processor count: 4
[16:26:31] [INF] Program data path: /config
[16:26:31] [INF] Web resources path: /jellyfin/jellyfin-web
[16:26:31] [INF] Application directory: /jellyfin/
[16:26:31] [INF] Setting cache path to /cache
[16:26:31] [INF] Loading assemblies
[16:26:33] [INF] Kestrel listening on all interfaces
[16:26:33] [INF] Running startup tasks
```
