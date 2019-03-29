# Dockerfiles

## Base images

When it is possible and I technicaly succeed, docker images are based on [distroless](https://github.com/GoogleContainerTools/distroless) (see lines with this tag: <kbd>distroless</kbd>).

"Distroless" images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

Some resources:
* [Distroless GitHub](https://github.com/GoogleContainerTools/distroless)
* [Distroless is for Security if not for size](https://medium.com/@dwdraju/distroless-is-for-security-if-not-for-size-6eac789f695f)


## My docker containers

* [`appDeploy`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/appDeploy) : A bash script, kind of `docker-compose` without the stack part to start container with secure parameters. It start a container and create all resources (volumes and networks) based on a simple config file.
* [`ghost`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/ghost) : Simple blog CMS ([Ghost](https://ghost.org/fr/)). <kbd>Distroless</kbd>
* [`rtorrent`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/rtorrent) : A torrent download tool ([rtorrent](https://github.com/rakshasa/rtorrent)). <kbd>Alpine</kbd>
* [`flood`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/flood) : A clean web interface for `rtorrent` ([flood](https://github.com/jfurrow/flood)). <kbd>Distroless</kbd>
* [`sslh`](https://github.com/LM1LC3N7/Dockerfiles/tree/master/sslh) : Applicative protocol multiplexer ([sslh](https://github.com/yrutschle/sslh)) usefull to use the 443 port with multiple protocols: `https` / `openvpn` / `ssh` / `shadowsocks`. <kbd>Alpine</kbd>


## Usefull commands

Docker layers number:

```bash
$> docker image inspect <image> -f '{{.RootFS.Layers}}' | wc -w
3
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

