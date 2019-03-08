# Ghost

Ce conteneur contient [Ghost](https://ghost.org) dans sa dernière version disponible sur [GitHub](https://github.com/TryGhost/Ghost/releases).
L'image récupère automatiquement la dernière `release` de [Ghost](https://ghost.org/fr/) et de [s6-overlay](https://github.com/just-containers/s6-overlay) pendant la création.

## Création de l'image

L'image est créée en deux étapes (avec le `multi-stage`) pour compiler les dépendences dans une première image, puis récupérer seulement les fichiers.
Cela permet d'obtenir une image finale bien plus légère avec très peu de couches (`layers`).

Détails à propos de l'image :

* Basée sur `node:10-alpine`
* 7 couches docker (`layers`)
* 284Mio, avec les dépendences `npm` nécessaires à `ghost`
* Lancement du service en moins de 10 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/ghost:latest -f '{{.RootFS.Layers}}' | wc -w
7
```

Avant de créer l'image, modifier la configuration de Ghost en fonction des besoins dans le fichier `rootfs/ghost/content/ghost.conf`.
Documentation officielle : https://docs.ghost.org/concepts/config/

```bash
docker build -t lmilcent/ghost .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Redémarrage automatique en cas de plantage
* Modification de la configuration de `ghost` avec les variables d'environnement
* Limitation des performances (2 CPUs, 512Mio de RAM, aucun SWAP)
* Limitation des autorisations ("Capabilities")
* Fonctionnement en mode utilisateur standard (pas de `root`)
* Interconnexion avec [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)
* TODO: Utiliser Traefik


```bash
docker run \
  --name="ghost" \
  --restart=unless-stopped \
  --stop-timeout=10 \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume ghost-content:/var/lib/ghost/content:rw \
  --cpus=2 \
  --memory=512m \
  --memory-swap=512m \
  --memory-swappiness=0 \
  --env-file /home/lmilcent/docker/ghost.env \
  --network=proxy \
  --cap-drop=all \
  --cap-add=ALL \
  --cap-add=chown \
  --cap-add=dac_override \
  --cap-add=fowner \
  --cap-add=setgid \
  --cap-add=setuid \
  lmilcent/ghost
```

**ghost.env**

```bash
## Nginx + companion
VIRTUAL_HOST=sub.domain.com
VIRTUAL_PORT=2368
VIRTUAL_PROTO=http
LETSENCRYPT_HOST=sub.domain.com 
LETSENCRYPT_EMAIL=my@email.com

## Ghost
NODE_ENV=production

# https://docs.ghost.org/concepts/config/
url=https://blog.lmilcent.com
```
