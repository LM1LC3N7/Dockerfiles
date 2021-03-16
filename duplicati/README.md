# Duplicati

Duplicati is a free, open source, backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers.
It is available on [GitHub](https://github.com/duplicati/duplicati/) and it works with:

   Amazon Cloud Drive and S3, Backblaze (B2), Box, Dropbox, FTP, Google Cloud and Drive, HubiC, MEGA, Microsoft Azure and OneDrive, Rackspace Cloud Files, OpenStack Storage (Swift), Sia, SSH (SFTP), WebDAV, and [more](https://duplicati.readthedocs.io/en/latest/01-introduction/#supported-backends)!


## Build

* **Base image:** Debian (`debian:10-slim`)
* **Duplicati version:** Last version available on [GitHub releases](https://github.com/duplicati/duplicati/releases)
* **Multi-stage:** No
* **Supervisor:** Yes, [`s6-overlay`](https://github.com/just-containers/s6-overlay#goals)
* **Low rights:** Yes, container started with real `root` rights, but Duplicati runs as normal user

Command:

```bash
docker-compose build duplicati
```

## Image details

* **Based on:**                 Debian
* **Layers:**                   4
* **Size:**                     729 Mio
* **Startup time:**             10 seconds
* **Auto-restart:**             Yes
* **Time Synchronization**      Yes, with host
* **Hardware limitations:**     4 CPU, 2048 Mio RAM, no SWAP
* **Low privileges:**           Yes, running using `app` user
* **Capabilities limitations:** Yes

This image is using the `proxy` network in order to contact the `traefik` container (a reverse proxy service).


## Before starting

All files and folders added to duplicati container (into `/backups/`) will have new ACL. This is a way to allow a non-root program to access to files that does not belong to him, without root permissions or group changes.
ACLs are created before each backups tasks (to be able to read new files) and gives only read permissions (no write access).

To reset ACLs you can use:

```bash
setfacl -bn <path>
```

## Start

Startup command, using `docker-compose up -d`:

```bash
$ docker-compose logs -f
Creating duplicati ... done
Attaching to duplicati
duplicati    | [s6-init] making user provided files available at /var/run/s6/etc...exited 0.
duplicati    | [s6-init] ensuring user provided files have correct perms...exited 0.
duplicati    | [fix-attrs.d] applying ownership & permissions fixes...
duplicati    | [fix-attrs.d] done.
duplicati    | [cont-init.d] executing container initialization scripts...
duplicati    | [cont-init.d] done.
duplicati    | [services.d] starting services
duplicati    | -----------------------------------------------
duplicati    |    _             _  _                     _
duplicati    |   | |           (_)| |                   | |
duplicati    |   | | _ __ ___   _ | |  ___   ___  _ __  | |_
duplicati    |   | || '_ \ _ \ | || | / __| / _ \| '_ \ | __|
duplicati    |   | || | | | | || || || (__ |  __/| | | || |_
duplicati    |   |_||_| |_| |_||_||_| \___| \___||_| |_| \__|
duplicati    |
duplicati    | -----------------------------------------------
duplicati    |  Application : Duplicati
duplicati    |  Running user: app
duplicati    |  User ID     : 8888
duplicati    |  Group ID    : 8888
duplicati    |  Base OS     : Debian
duplicati    | -----------------------------------------------
duplicati    |  Duplicati configuration
duplicati    |    - Config folder : /config
duplicati    | -----------------------------------------------
duplicati    | [*] Applying setuid and permissions to /apply-backup-acl.sh
duplicati    | [*] Applying acl to /backups/*
duplicati    | Apply ACL to /backups
duplicati    | setfacl -R -m user:8888:rX /backups
duplicati    | [services.d] done.
duplicati    | setfacl -R -m group:8888:rX /backups
duplicati    | [*] Applying rights to /config/*
duplicati    | [*] Applying acl to /restore/*
duplicati    | Apply ACL to /restore
duplicati    | setfacl -R -m user:8888:rX /restore
duplicati    | setfacl -R -m group:8888:rX /restore
duplicati    | [*] Starting Duplicati
duplicati    |
duplicati    | 2021-03-16 16:02:19 +01 - [Information-Duplicati.Server.WebServer.Server-ServerListening]: Server has started and is listening on 0.0.0.0, port 8200
```



## Duplicati Options for a backup task
On the main page, click on "Settings" and then paste the following into "Default options" input ([see official example](https://github.com/duplicati/duplicati/blob/master/Duplicati/Library/Modules/Builtin/run-script-example.sh)):

```
--aes-set-threadlevel=4
--all-versions=true
--asynchronous-concurrent-upload-limit=5
--auto-cleanup=true
--auto-vacuum=true
--block-hash-algorithm=SHA256
--console-log-level=Warning
--exclude-empty-folders=true
--log-retention=30D
--restore-path=/restore
--retry-delay=10s
--run-script-before=/apply-backup-group.sh
--run-script-timeout=5m
--send-mail-any-operation=true
--send-mail-from=no-reply@your.domain.tld
--send-mail-level=Warning,Error
--send-mail-log-level=Warning
--send-mail-max-log-lines=100
--send-mail-password=your-sparkpostmail-api-token
--send-mail-url=smtp://smtp.sparkpostmail.com:587?starttls=always
--send-mail-username=SMTP_Injection
--send-mail-to=your@email.tld
--zip-compression-zip64=true
--zip-compression-method=LZMA
```
