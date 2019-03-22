# Dockerfiles

## Distroless

Dès que possible et que j'y arrive, les images utilisent [distroless](https://github.com/GoogleContainerTools/distroless) comme image de base.
Cela permet de limiter les risques en faisant tourner les processus dans un environnement contenant seulement les dépendances (pas de `sh` ni aucun paquet linux).

Quelques sources :

* [Distroless is for Security not for size](https://medium.com/@dwdraju/distroless-is-for-security-if-not-for-size-6eac789f695f)
* [Smaller Docker Images](https://learnk8s.io/blog/smaller-docker-images/)


## Liste des services

* [`appDeploy`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/appDeploy) : Un script bash permettant d'utiliser des fichiers de configuration pour automatiquement créer et déployer des images docker (sécurisée).
* [`ghost`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/ghost) : Application de blog [Ghost](https://ghost.org/fr/).
* [`rtorrent`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/rtorrent-flood) : Un service de téléchargement de torrent avec [`flood`](https://github.com/jfurrow/flood) comme interface.


## Licence
Licence MIT : permission de faire ce que vous voulez avec, sans aucune garantie de ma part.

