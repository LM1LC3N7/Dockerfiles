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
* [`rtorrent`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/rtorrent) : Un service de téléchargement de torrent.
* [`flood`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/flood) : Une interface web pour rtorrent.
* [`sslh`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/sslh) : Un outil pour utiliser le port 443 et y faire transiter différents protocoles : https / openvpn / ssh / shadowsocks.

## Licence
Licence MIT : permission de faire ce que vous voulez avec, sans aucune garantie de ma part.

