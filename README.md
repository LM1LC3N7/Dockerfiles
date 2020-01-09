# Dockerfiles

## Base images

When it is possible and I technicaly succeed, docker images are based on [distroless](https://github.com/GoogleContainerTools/distroless) (see lines with this tag: <kbd>distroless</kbd>).

"Distroless" images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

Some resources:
* [Distroless GitHub](https://github.com/GoogleContainerTools/distroless)
* [Distroless is for Security if not for size](https://medium.com/@dwdraju/distroless-is-for-security-if-not-for-size-6eac789f695f)


## Securely deploy containers

My commandments are:
* Limit container resources (avoid that one container use all resources)
* Limit container rights by dropping linux capabilities by default
* Create my own image based on distroless or alpine to limit the surface attack

I use docker-compose [v2.4](https://docs.docker.com/compose/compose-file/compose-file-v2/) because the [v3 does not allow resource limiting on a docker host non-swarm](https://github.com/docker/compose/issues/4513).


## My docker containers

* [`ghost`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/ghost) : Simple blog CMS ([Ghost](https://ghost.org/fr/)). <kbd>Distroless</kbd>
* [`netdata`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/netdata) : [Netdata](https://github.com/firehol/netdata) is a real-time, performance and health monitoring for systems and applications. <kbd>Alpine</kbd>
* [`rtorrent`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/seedbox/rtorrent) : A torrent download tool ([rtorrent](https://github.com/rakshasa/rtorrent)). <kbd>Alpine</kbd>
* [`flood`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/seedbox/flood) : A clean web interface for `rtorrent` ([flood](https://github.com/jfurrow/flood)). <kbd>Distroless</kbd>
* [`sslh`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/sslh) : Applicative protocol multiplexer ([sslh](https://github.com/yrutschle/sslh)) usefull to use the 443 port with multiple protocols: `https` / `openvpn` / `ssh` / `shadowsocks`. <kbd>Alpine</kbd>


## Usefull commands

Docker layers number:

```bash
$> docker image inspect <image> -f '{{.RootFS.Layers}}' | wc -w
3
```

Image size:

```bash
$> docker images <image>:<tag>
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<image>             <tag>               a12b345cd67e        3 days ago          16.2MB
```

-----

## License
MIT License

Copyright (c) 2019 Louis MILCENT

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

