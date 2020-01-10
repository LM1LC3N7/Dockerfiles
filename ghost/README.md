# Ghost

Ghost is a blogging plateform open-source and available on [GitHub](https://ghost.org)
This docker image automatically download the last version from [GitHub releases](https://github.com/TryGhost/Ghost/releases).


## Build

* **Base image:** Distroless
* **Ghost version:** Last version available on the GitHub project
* **Multi-stage:** Yes
* **Supervisor:** No

Command:

```bash
docker-compose build ghost
```


## Image details

* **Based on:** Distroless
* **Layers:** 9
* **Size:** 277 Mio
* **Startup time:** 3 seconds
* **Auto-restart:** yes
* **Time Synchronization** no
* **Hardware limitations:** 1 CPU, 256 Mio RAM, no SWAP
* **Low privileges** no
* **Capabilities limitations:** none

This image is using the `proxy` network in order to contact the `traefik` container (a proxy service) and is also connected to `ghost-backend` to contact the database.


## Before starting
Before starting a new instance, the configuration should be updated in `SECRET.env` for passwords and `ghost.env` for configuration.

**SECRET.env**

```bash
declare -x GHOST_DB_SECRET="pass"
declare -x GHOST_MYSQL_ROOT_SECRET="pass"
declare -x GHOST_MYSQL_SECRET="pass"
declare -x GHOST_SMTP_HOST="smtp.example.tld"
declare -x GHOST_SMTP_USER="user"
declare -x GHOST_SMTP_SECRET="pass"
```

**ghost.env**

```bash
## CONFIG
NODE_ENV=production
database__client=mysql
database__connection__host=ghost-db
database__connection__user=ghost
database__connection__database=ghost
database__debug=false
url=https://blog.example.tld
server__host=0.0.0.0
server__port=2368
mail__transport=SMTP
mail__options__port=587
mail__from=blog@example.tld
imageOptimization__resize=true
```


## Start

Startup command, using `docker-compose up -d`:

```bash
$ docker logs -f ghost
[2020-01-09 17:33:30] WARN Theme's file locales/fr.json not found.
[2020-01-09 17:33:30] WARN Falling back to locales/en.json.
[2020-01-09 17:33:30] WARN Theme's file locales/en.json not found.
[2020-01-09 17:33:32] INFO Ghost is running in production...
[2020-01-09 17:33:32] INFO Your site is now available on https://blog.example.tld/
[2020-01-09 17:33:32] INFO Ctrl+C to shut down
[2020-01-09 17:33:32] INFO Ghost boot 3.669s
```
