# Rtorrent

Ce conteneur contient `rtorrent` dans sa dernière version 0.9.7-r1 ([packages alpine](https://pkgs.alpinelinux.org/packages?name=rtorrent&branch=edge)).
À partir de la version 0.9.7, `rtorrent` permet d'être lancé en tant que démon, plus besoin d'utiliser `screen` ou `tmux` !

L'interface utilisée est [jfurrow/flood](https://github.com/jfurrow/flood), dans sa dernière version disponible sur la branche `master`, disponible dans un `Dockerfile` dédié.



## Création de l'image

L'image récupère automatiquement la dernière version `rtorrent` et de [s6-overlay](https://github.com/just-containers/s6-overlay) pendant la création.
  
Détails à propos de l'image :

* Basée sur `alpine:3.9`
* 3 couches docker (`layers`)
* 32.6Mio seulement
* Lancement du service en moins de 8 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/rtorrent:alpine -f '{{.RootFS.Layers}}' | wc -w
3
```

Créer l'image :

```bash
docker build -t lmilcent/rtorrent:alpine .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Redémarrage automatique en cas de plantage
* Volumes accessible contenant les fichiers téléchargés et torrents
* Limitation des performances (2 CPUs, 1Gio de RAM, aucun SWAP)
* Limitation des autorisations ("Capabilities")
* Fonctionnement en mode utilisateur standard (pas de `root`)
* Interconnexion avec Traefik


```bash
docker run \
  --tty \
  --name="rtorrent" \
  --restart=unless-stopped \                                                                                                                                                                                                     [29/1193]
  --stop-timeout=10 \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume /data/medias/downloaded:/app/rtorrent/download:rw \
  --volume rtorrent-config:/app/rtorrent/config:rw \
  --cpus=2 \
  --memory=1024m \
  --memory-swap=1024m \
  --memory-swappiness=0 \
  --publish 49184:49184 \
  --publish 49184:49184/udp \
  --network=proxy \
  --cap-drop=all \
  --cap-add=chown \
  --cap-add=fowner \
  --cap-add=setgid \
  --cap-add=setuid \
  --cap-add=dac_override \
  lmilcent/rtorrent:alpine
```
