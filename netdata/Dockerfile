# Source: https://hub.docker.com/r/netdata/builder/dockerfile
#         https://github.com/netdata/netdata/blob/master/packaging/docker/Dockerfile
#         https://hub.docker.com/r/netdata/base/dockerfile


FROM alpine:3.9

ENV PUID=991 \
    PGID=991 \
    LISTEN_IP=0.0.0.0 \
    LISTEN_PORT=19999

RUN echo \
 && echo "[*] Installing build dependencies" \
 && apk add -Uu --no-cache --purge \
      autoconf \
      automake \
      build-base \
      curl \
      libmnl-dev \
      util-linux-dev \
      zlib-dev \
      json-c-dev \
      libuv-dev \
      libmnl \
      libuuid \
      bash \
      pkgconfig \
 && echo \
 && echo "[*] Creating netdata user and group" \
 && addgroup -g ${PGID} netdata \
 && adduser -D -H -u ${PUID} -G netdata netdata \
 && echo \
 && echo "[*] Searching for the last netdata version from github" \
 && cd /tmp \
 && VERSION=$(curl -jksL https://api.github.com/repos/netdata/netdata/releases/latest | awk '/tag_name/{print $4;exit}' FS='[""]' | sed -e 's_^v__') \
 && echo \
 && echo "[*] Downloading netdata version ${VERSION} from github" \
 && curl -sSL https://github.com/netdata/netdata/releases/download/v${VERSION}/netdata-v${VERSION}.tar.gz | tar xz \
 && cd netdata-v${VERSION} \
 && echo \
 && echo "[*] Building netdata" \
 && ./netdata-installer.sh --dont-wait --dont-start-it \
 && echo \
 && echo "[*] Fix files permissions" \
 && chown -R netdata:netdata /usr/share/netdata/web /var/lib/netdata /var/cache/netdata /var/log/netdata \
 && echo "[*] Searching the last version of s6-overlay" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && S6_VER="${S6_VER:1}" \
 && echo \
 && echo "[*] Downloading s6-overlay version v${S6_VER} from github" \
 && cd /tmp && wget -q https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] Installing s6-overlay" \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
 && echo \
 && echo "[*] Cleaning" \
 && apk del \
      autoconf \
      automake \
      build-base \
      curl \
      libmnl-dev \
      util-linux-dev \
      zlib-dev \
 && rm -rf /var/cache/apk/* /tmp/*

COPY rootfs/etc/services.d/netdata/run /etc/services.d/netdata/run
COPY rootfs/netdata.conf /etc/netdata/netdata.conf

EXPOSE 19999

ENTRYPOINT ["/init"]
