# Rtorrent avec interface flood

Ce conteneur contient `rtorrent` dans sa dernière version 0.9.7-r1 ([packages alpine](https://pkgs.alpinelinux.org/packages?name=rtorrent&branch=edge)).
À partir de la version 0.9.7, `rtorrent` permet d'être lancé en tant que démon, plus besoin d'utiliser `screen` ou `tmux` !

L'interface utilisée est [jfurrow/flood](https://github.com/jfurrow/flood), dans sa dernière version disponible sur la branche `master`.


## Création de l'image

L'image est créée en deux étapes (avec le `multi-stage`) pour compiler les dépendences dans une première image, puis récupérer seulement les fichiers.
Cela permet d'obtenir une image finale bien plus légère avec très peu de couches (`layers`).

Détails à propos de l'image :

* Basée sur `node:10-alpine`
* 6 couches docker (`layers`)
* 388Mio, avec les dépendences `npm` nécessaires à `flood`
* Lancement du service en moins de 10 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/flood:latest -f '{{.RootFS.Layers}}' | wc -w
6
```

Créer l'image :

```bash
docker build -t lmilcent/flood .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Redémarrage automatique en cas de plantage
* Sauvegarde de la configuration de flood dans un volume
* Limitation des performances (2 CPUs, 1Gio de RAM, aucun SWAP)
* Limitation des autorisations ("Capabilities")
* Fonctionnement en mode utilisateur standard (pas de `root`)
* Interconnexion avec [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)
* TODO: Utiliser Traefik


```bash
docker create \
  --tty \
  --name="flood" \
  --restart=unless-stopped \
  --stop-timeout=10 \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume /data/medias/downloaded:/app/rtorrent/download:rw \
  --volume rtorrent-flood-db:/app/flood/flood-db:rw \
  --volume rtorrent-config:/app/rtorrent/config:rw \
  --cpus=2 \
  --memory=1024m \
  --memory-swap=1024m \
  --memory-swappiness=0 \
  --env-file /home/lmilcent/docker/rtorrent/flood.env \
  --publish 49184:49184 \
  --network=proxy \
  --cap-drop=all \
  --cap-add=chown \
  --cap-add=fowner \
  --cap-add=setgid \
  --cap-add=setuid \
  --cap-add=dac_override \
  lmilcent/flood:latest
```

**flood.env**

```bash
VIRTUAL_HOST=subdomain.domain.com
VIRTUAL_PORT=3000
VIRTUAL_PROTO=http
LETSENCRYPT_HOST=subdomain.domain.com
LETSENCRYPT_EMAIL=my@email.com
FLOOD_SECRET=SECRET_A_CHANGER
FLOOD_ENABLE_SSL=false
```
