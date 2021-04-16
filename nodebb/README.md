# NodeBB

NodeBB is the "next generation forum". It utilizes web sockets for instant interactions and real-time notifications.

This image:
* allow to use the `restart` and `build` buttons from NodeBB web interface
* start NodeBB with users rights (not as root)
* updates plugins and the OS at boot


## Build the image
This docker image automatically download the last version of NodeBB from [GitHub](https://github.com/NodeBB/NodeBB).
The last version of [S6-overlay](https://github.com/just-containers/s6-overlay/releases) is also downloaded and installed.
Lastly, the build is using multi-stage to reduce the final image weight and layers number to improve performances.

<!--
To get image details, use:
docker image inspect <image> -f '{{.RootFS.Layers}}' | wc -w
docker images <image>:<tag>
-->

* **Base image:** node:14-alpine
* **NodeBB version:** Last version available on GitHub (official release)
* **Multi-stage:** Yes
* **Layers:** 10
* **Size:** 591 Mio (including all plugins dependencies)
* **Supervisor:** Yes (s6-overlay)
* **Startup time:** 35 seconds (depend on the build time and plugins number, value for a 4 cores CPU)
* **Auto-restart:** yes
* **Time Synchronization** yes
* **Hardware limitations:** 4 CPU, 1512 Mio RAM, no SWAP
* **Low privileges:** yes
* **Capabilities limitations:** yes

Build command:

```bash
docker-compose build nodebb
```

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service) and is also connected to `nodebb-backend` to contact the database on a separate network.


## Before starting
Before starting a new instance:
  - the configuration should be updated in `rootfs/nodebb/config.json` to suits your needs
  - the URL has to be updated in `SECRET.env` (used only for traefik)
  - a Redis password should be set in `SECRET.env` for both containers redis and nodebb
  - update the plugin to install list in `rootfs/etc/nodebb/active-plugins`

**SECRET.env**

```bash
declare -x NODEBB_TRAEFIK_URL="sub.domain.tld"
declare -x NODEBB_REDIS_PASSWORD="something-random-7pNdBYTzdT58EWkA9R9KGSQ"
```

An example is provided in `rootfs/nodebb/config.example.json`.

**config.json**

Note: The redis password will automatically be updated by the environment variable for `redis` and `session_store`.

```bash
{
  "url": "https://sub.domain.tld",
  "secret": "some-random-password-E9d0g%8DQKiQe5AiWobVU9",
  "database": "redis",
  "redis": {
    "host": "nodebb-redis",
    "port": "6379",
    "password": "",
    "database": "0"
  },
  "port": "4567",
  "bcrypt_rounds": "21",
  "bind_address": "0.0.0.0",
  "isCluster": "false",
  "session_store": {
    "name": "redis",
    "host": "nodebb-redis",
    "port": "6379",
    "password": "",
    "database": "0"
  }
}

```

**active-plugins**
File only used during the **image build**. Two other files are used to keep a list of enabled and disabled plugins accross container (re) creations.

```bash
nodebb-plugin-category-notifications@3.0.3
nodebb-plugin-category-optin@2.0.0
nodebb-plugin-composer-quill@1.8.0
nodebb-plugin-dbsearch@4.2.0
nodebb-plugin-embed@3.0.19
nodebb-plugin-emoji@3.5.1
nodebb-plugin-emoji-one@2.0.5
nodebb-plugin-imagemagick@2.1.1
nodebb-plugin-lastlife-registration-question@0.1.0
nodebb-plugin-mentions@2.13.9
nodebb-plugin-private-forum@1.2.0
nodebb-plugin-question-and-answer@0.8.7
nodebb-plugin-registration-notification@1.2.5
nodebb-plugin-telegram-notifications-plus@1.0.4
nodebb-rewards-essentials@0.1.4
nodebb-theme-persona@10.3.19
nodebb-widget-essentials@5.0.3
nodebb-widget-search-bar@1.1.2
```

## Start
At first startup, NodeBB is installed, built and started.
A random admin password is generated for the first time.

Startup workflow:
1. OS upgrade
2. Configuration update and redis password update using the environment variable
3. NodeBB upgrade if needed (for configuration changes)
4. NodeBB setup (for first installation) and build
5. Kill all remaining processes (a bug it seems)
6. Installing and activating all plugins listed in `active-plugins`
7. Starting NodeBB
8. When the container is stopped, saving a list of all installed plugins and the configuration file

To start the container:

```bash
$ . SECRET.env
$ docker-compose up -d
$ docker logs -f nodebb
[..] (NodeBB build logs)
nodebb    | [services.d] starting services
nodebb    | -----------------------------------------------
nodebb    |    _             _  _                     _
nodebb    |   | |           (_)| |                   | |
nodebb    |   | | _ __ ___   _ | |  ___   ___  _ __  | |_
nodebb    |   | || '_ \ _ \ | || | / __| / _ \| '_ \ | __|
nodebb    |   | || | | | | || || || (__ |  __/| | | || |_
nodebb    |   |_||_| |_| |_||_||_| \___| \___||_| |_| \__|
nodebb    |
nodebb    | -----------------------------------------------
nodebb    |  Application : nodebb
nodebb    |  Running user: nodebb
nodebb    |  Base OS     : Alpine
nodebb    | -----------------------------------------------
nodebb    |  NodeBB configuration
nodebb    |    - Installation path  : /nodebb
nodebb    |    - Running as user    : nodebb
nodebb    |    - UID & GID          : 991
nodebb    |    - Configuration file : /etc/nodebb/config.json
nodebb    | -----------------------------------------------
nodebb    |
nodebb    | -------------------------------
nodebb    | [*] New installation detected.
nodebb    |
nodebb    | [services.d] done.
nodebb    | An administrative user was automatically created for you:
nodebb    |     Username: admin
nodebb    |     Password: cdb9343d
nodebb    |
nodebb    | -------------------------------
nodebb    |
nodebb    | [*] Starting Nodebb
nodebb    |
nodebb    | Starting NodeBB
nodebb    |   "./nodebb stop" to stop the NodeBB server
nodebb    |   "./nodebb log" to view server output
nodebb    |   "./nodebb help" for more commands
nodebb    |
nodebb    |
nodebb    | NodeBB v1.13.3 Copyright (C) 2013-2014 NodeBB Inc.
nodebb    | This program comes with ABSOLUTELY NO WARRANTY.
nodebb    | This is free software, and you are welcome to redistribute it under certain conditions.
nodebb    | For the full license, please visit: http://www.gnu.org/copyleft/gpl.html
nodebb    |
nodebb    | Clustering enabled: Spinning up 1 process(es).
nodebb    |
nodebb    | 2020-05-26T08:42:08.984Z [4567/426] - info: Initializing NodeBB v1.13.3 http://sub.domain.com
nodebb    | 2020-05-26T08:42:10.769Z [4567/426] - info: [socket.io] Restricting access to origin: http://sub.domain.com:*
nodebb    | 2020-05-26T08:42:11.116Z [4567/426] - info: Routes added
nodebb    | 2020-05-26T08:42:11.118Z [4567/426] - info: NodeBB Ready
nodebb    | 2020-05-26T08:42:11.120Z [4567/426] - info: Enabling 'trust proxy'
nodebb    | 2020-05-26T08:42:11.122Z [4567/426] - info: NodeBB is now listening on: 0.0.0.0:4567
```
