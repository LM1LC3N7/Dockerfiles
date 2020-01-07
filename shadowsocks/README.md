# Shadowsocks

TODO: Work in progess

[Shadowsocks](https://github.com/shadowsocks) is a secure socks5 proxy, designed to protect your Internet traffic.`
The version 1.0 has been ported in `go`. There is also a [version 2.0](https://github.com/shadowsocks/go-shadowsocks2) less active and a [web UI](https://github.com/shadowsocks/shadowsocks-manager).


## Build

* **Base image:** Distroless
* **`shadowsocks` version:** Last version (clone of the GitHub project on build)
* **Multi-stage:** Yes, from debian
* **Supervisor:** No

Command:

```bash
docker build -t lmilcent/shadowsocks:distroless .
```


## Image details

* **Based on:** Distroless
* **Layers:** TODO:
* **Size:** TODO: Mio
* **Startup time:** TODO: seconds
* **Auto-restart:** yes
* **Time Synchronization** no
* **Hardware limitations:** TODO: CPU, ?? Mio RAM, no SWAP
* **Low privileges** No but there is no users nor cmd
* **Capabilities limitations:** None

<!-- This image is using the `proxy` network in order to contact the `traefik` container (a proxy service). -->

Startup command, using the `appDeploy/startContainer` script:

```bash
startContainer shadowsocks.cfg
```

Command generated by the script:

```bash
docker run \
  --tty \
  --detach \
  --name="shadowsocks" \
  --restart=unless-stopped \
  --stop-timeout=10 \
  --cpus=TODO: \
  --memory=TODO:m \
  --memory-swap=TODO:m \
  --memory-swappiness=0 \
  --publish 8388:8388/tcp \
  --cap-drop=all \
  lmilcent/shadowsocks:distroless
```