# Ghost

Ce conteneur contient [Ghost](https://ghost.org) dans sa dernière version disponible sur [GitHub](https://github.com/TryGhost/Ghost/releases).


## Création de l'image

L'image est créée en deux étapes (avec le `multi-stage`) pour compiler les dépendences dans une première image, puis récupérer seulement les fichiers.
Cela permet d'obtenir une image finale bien plus légère avec très peu de couches (`layers`).

Détails à propos de l'image :

* Basée sur `node:10-alpine`
* 7 couches docker (`layers`)
* 287Mio, avec les dépendences `npm` nécessaires à `ghost`
* Lancement du service en moins de 10 secondes !

Nombres de couches docker :

```bash
$> docker image inspect lmilcent/ghost:latest -f '{{.RootFS.Layers}}' | wc -w
7
```

Créer l'image :

```bash
docker build -t lmilcent/ghost .
```


## Lancement du conteneur

Le conteneur est lancé avec différentes options :

* Redémarrage automatique en cas de plantage
* Modification de la configuration de `ghost` avec les variables d'environnement
* Limitation des performances (2 CPUs, 1Gio de RAM, aucun SWAP)
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
  lmilcent/ghost:alpine
```

**ghost.env**

```bash
## Nginx + companion
VIRTUAL_HOST=blog.lmilcent.com
VIRTUAL_PORT=2368
VIRTUAL_PROTO=http
LETSENCRYPT_HOST=blog.lmilcent.com 
LETSENCRYPT_EMAIL=louis@lmilcent.com

## Ghost
NODE_ENV=production

# https://docs.ghost.org/concepts/config/
url=https://blog.lmilcent.com
mail__transport=SMTP 
mail__from=blog@lmilcent.com 
mail__options__service=sparkpost 
mail__options__auth__user=SMTP_Injection 
mail__options__auth__pass=TOKEN 
server__host=0.0.0.0
server__port=2368
logging__level=info 
imageOptimization__resize=true
compress=true 
preloadHeaders=true
sendWelcomeEmail=true
```
