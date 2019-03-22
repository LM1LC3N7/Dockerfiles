# Interface flood pour rtorrent

Le projet [jfurrow/flood](https://github.com/jfurrow/flood) est une interface web pour `rtorrent`.



## Création de l'image

L'image récupère la dernière version de `flood` depuis le projet sur `GitHub` (branche master).

L'image est créée en deux étapes (avec le `multi-stage`) pour compiler les dépendences dans une première image, puis récupérer seulement les fichiers.
Cela permet d'obtenir une image finale bien plus légère avec très peu de couches (`layers`).
L'avantage de l'image de base `distroless` :
1. Moins de surface d'attaque
2. Seulement les dépendances nécessaire au service
3. Pas de vulnérabilités liées à l'OS embarqué
4. Variables d'environnement secretes, car `docker exec` ne permet pas d'ouvrir un shell et de les afficher
5. `glibc` est utilisé, assurant une meilleure compatibilité


Détails à propos de l'image :

* Basée sur [`distroless`](https://github.com/GoogleContainerTools/distroless)
* 6 couches docker (`layers`)
* 363Mio, avec les dépendences `npm` nécessaires à `flood`
* Lancement du service en moins de 5 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/flood:distroless -f '{{.RootFS.Layers}}' | wc -w
6
```

Créer l'image :

```bash
docker build -t lmilcent/flood:distroless .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Redémarrage automatique en cas de plantage
* Sauvegarde de la configuration de flood dans un volume
* Limitation des performances (0.5CPUs, 150Mio de RAM, aucun SWAP)
* Limitation des autorisations ("Capabilities")
* Interconnexion avec Traefik


```bash
docker run \
  --label "traefik.enable=true" \
  --label "traefik.frontend.rule=Host:subdomain.domain.com" \
  --label "traefik.port=3000" \
  --label "traefik.docker.network=proxy" \
  --label "traefik.backend=rTorrent" \
  --label "traefik.frontend.entryPoints=http,https" \
  --label "traefik.frontend.redirect.entryPoint=https" \
  --label "traefik.protocol=http" \
  --name="flood-distroless" \
  --restart=unless-stopped \
  --stop-timeout=5 \
  --volume rtorrent-flood-db:/app/flood/flood-db:rw \
  --cpus=0.5 \
  --memory=150m \
  --memory-swap=150m \
  --memory-swappiness=0 \
  --env-file /home/user/docker/rtorrent/flood.env \
  --network=proxy \
  lmilcent/flood:distroless
```

**flood.env**

```bash
FLOOD_SECRET=FloodSecret-ToChange!
FLOOD_ENABLE_SSL=false
RTORRENT_SCGI=5000
RTORRENT_SCGI_HOST=127.0.0.1
RTORRENT_SOCK=false
```
