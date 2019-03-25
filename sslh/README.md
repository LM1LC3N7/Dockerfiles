# Outil SSLH

Le projet [yrutschle/sslh](https://github.com/yrutschle/sslh) est un multiplexeur permettant d'utiliser un seul port (le port 443) pour différents procotoles (https / ssh / openvpn / shadowsocks).



## Création de l'image

L'image récupère la dernière version de `sslh` disponible dans les [dépôts](http://dl-3.alpinelinux.org/alpine/edge/testing/) d'Alpine.

L'image est créée en deux étapes (avec le `multi-stage`) pour compiler les dépendences dans une première image, puis récupérer seulement les fichiers.
Cela permet d'obtenir une image finale bien plus légère avec très peu de couches (`layers`).

Détails à propos de l'image :

* Basée sur Alpine Linux
* 3 couches docker (`layers`)
* 16,2 Mio
* Lancement du service en moins de 10 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/sslh:alpine -f '{{.RootFS.Layers}}' | wc -w
3
```

Créer l'image :

```bash
docker build -t lmilcent/sslh:alpine .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Redémarrage automatique en cas de plantage
* Sauvegarde de la configuration de flood dans un volume
* Limitation des performances (0.5CPUs, 10Mio de RAM, aucun SWAP)
* Limitation des autorisations ("Capabilities")

```bash
docker run \
  --tty \
  --detach \
  --name="sslh" \
  --restart=unless-stopped \
  --stop-timeout=10 \
  --volume /etc/localtime:/etc/localtime:ro \
  --cpus=0.5 \
  --memory=10m \
  --memory-swap=10m \
  --memory-swappiness=0 \
  --env-file /home/lmilcent/docker/Dockerfiles/sslh/sslh.env \
  --publish 443:443/tcp \
  --network=proxy \
  --cap-drop=all \
  --cap-add=setgid \
  --cap-add=setuid \
  --cap-add=net_bind_service \
  --cap-add=setfcap \
  lmilcent/sslh:alpine
```

**sslh.env**

```bash
# Listening port / host
LISTEN_IP=0.0.0.0
LISTEN_PORT=443

# Use WAN address for server SSH
SSH_HOST=domain.com
SSH_PORT=22

# OpenVPN container name
OPENVPN_HOST=pritunl
OPENVPN_PORT=1194

# Traefik container name
HTTPS_HOST=traefik
HTTPS_PORT=443

# No Shadow Socks for now.
SHADOWSOCKS_HOST=localhost
SHADOWSOCKS_PORT=8388

```
