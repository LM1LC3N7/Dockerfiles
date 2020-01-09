# Duplicati

Duplicati is a free, open source, backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers.
It is available on [GitHub](https://github.com/duplicati/duplicati/) and it works with:

   Amazon Cloud Drive and S3, Backblaze (B2), Box, Dropbox, FTP, Google Cloud and Drive, HubiC, MEGA, Microsoft Azure and OneDrive, Rackspace Cloud Files, OpenStack Storage (Swift), Sia, SSH (SFTP), WebDAV, and [more](https://duplicati.readthedocs.io/en/latest/01-introduction/#supported-backends)!


## Build

* **Base image:** Debian (`mono:5-slim`)
* **`Duplicati` version:** Last version available on [GitHub releases](https://github.com/duplicati/duplicati/releases)
* **Multi-stage:** No
* **Supervisor:** Yes, [`s6-overlay`](https://github.com/just-containers/s6-overlay#goals)

Command:

```bash
docker-compose build duplicati
```

## Image details

* **Based on:** Debian
* **Layers:** 4
* **Size:** 718 Mio
* **Startup time:** 10 seconds
* **Auto-restart:** yes
* **Time Synchronization** yes, with host
* **Hardware limitations:** 2 CPU, 1024 Mio RAM, no SWAP
* **Low privileges** yes, running using `app` user
* **Capabilities limitations:** No, for now :-(

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service).


## Before starting

You MUST create a new group **on the host**, named `duplicati-backup` with gid=1111:

```bash
sudo groupadd --gid 1111 duplicati-backup
```

All files and folders added to duplicati container (into `/backups/`) will be added to this group.
Also, they should be at least readable for the group. For example:

```bash
find /backups -type f -exec chmod 00660 {} \;
find /backups -type d -exec chmod 00770 {} \;
find /backups -type f -iname "*.sh" -exec chmod 00770 {} \;
```

## Start

Startup command, using `docker-compose up -d`:

```bash
$ docker logs -f duplicati
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
  | | _ __ ___   _ | |  ___   ___  _ __  | |_
  | || '_ \ _ \ | || | / __| / _ \| '_ \ | __|
  | || | | | | || || || (__ |  __/| | | || |_
  |_||_| |_| |_||_||_| \___| \___||_| |_| \__|

-----------------------------------------------
 Application : Duplicati
 Running user: app
 Base OS     : Debian
-----------------------------------------------
 Duplicati configuration
   - Config folder : /config
-----------------------------------------------
[*] Applying permissions to /apply-backup-group.sh
[services.d] done.
[*] Applying permissions to /config
[*] Applying permissions to /restore
[*] Applying permissions to /backups
[*] Starting Duplicati
```



## Duplicati Options
On the main page, click on "Settings" and then paste the following into "Default options" input:

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
