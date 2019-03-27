# Ghost

Ce conteneur contient [Ghost](https://ghost.org) dans sa dernière version disponible sur [GitHub](https://github.com/TryGhost/Ghost/releases).
L'image récupère automatiquement la dernière `release` de [Ghost](https://ghost.org/fr/).

## Création de l'image

L'image est créée en deux étapes (avec le `multi-stage`) pour compiler les dépendences dans une première image, puis récupérer seulement les fichiers.
Cela permet d'obtenir une image finale bien plus légère avec très peu de couches (`layers`) en se basant sur Distoless.

Détails à propos de l'image :

* Basée sur `distroless`
* 8 couches docker (`layers`)
* 220Mio, avec les dépendences `npm` nécessaires à `ghost` et le thème supplémentaire `caffeine`
* Lancement du service en moins de 8 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/ghost:distroless -f '{{.RootFS.Layers}}' | wc -w
8
```

Avant de créer l'image, modifier la configuration de Ghost en fonction des besoins dans le fichier `rootfs/ghost/content/ghost.conf`.
Documentation officielle : https://docs.ghost.org/concepts/config/

```bash
docker build -t lmilcent/ghost:distroless .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Modification de la configuration de `ghost` avec les variables d'environnement
* Limitation des performances (2 CPUs, 512Mio de RAM, aucun SWAP)
* Limitation des autorisations ("Capabilities")
* Interconnexion avec Traefik


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
  lmilcent/ghost:distroless
```

**ghost.env**

```bash
## Ghost
NODE_ENV=production

# https://docs.ghost.org/concepts/config/
url=https://blog.lmilcent.com
database__connection__host=ghost-db
database__connection__user=ghost
database__connection__password=ghostPassword-ToChange
database__connection__database=ghost
```
