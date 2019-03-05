#
# Multi-stage Dockerfile
#


#
# Stage 1:
# ----- Building flood -----
#

FROM alpine:3.9 as flood-build

COPY rootfs/app/flood/config.js /app/flood/config.js

RUN echo \
 && echo "[*] Updating OS" \
 && apk -U upgrade \
 && echo \
 && echo "[*] Installing flood dependencies" \
 && apk add --no-cache \
    nodejs \
    nodejs-npm \
 && apk add --no-cache --virtual=build-dependencies \
    python \
    make \
    g++ \
    git \
    curl \
    tar \
 && echo \
 && echo "[*] Installing flood" \
 && echo \
 && mkdir -p /app/flood && cd /app/flood \
 && mv /app/flood/config.js /tmp \
 && git clone https://github.com/jfurrow/flood.git . \
 && mv /tmp/config.js /app/flood \
 && npm install \
 && echo \
 && echo "[*] Building flood assets" \
 && npm run build \
 && npm prune --production \
 && npm cache clean --force \
 && echo \
 && echo "[*] Importing files (UID=991, GID=991) from first docker build stage to second (could be long as there is $(find /app -type f | wc -l) files, approx. 320Mio)." && echo


#
# Stage 2:
# ----- Creating final image -----
#
FROM node:10-alpine

ENV S6_FIX_ATTRS_HIDDEN=1 \
   RTORRENT_HOME=/app/rtorrent \
   UID=991 \
   GID=991 \
   TERM=xterm

COPY --chown=991:991 --from=flood-build /app/flood /app/flood
COPY rootfs /

RUN echo \
 && echo "[*] Updating OS" \
 && apk -U upgrade \
 && echo \
 && echo "[*] Installing rtorrent last version from edge repository" \
 && apk add rtorrent mediainfo \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
 && echo \
 && echo "[*] Installing flood dependencies" \
 && apk add --no-cache \
    curl \
 && echo "[*] Searching the last version of s6-overlay" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && S6_VER="${S6_VER:1}" \
 && echo \
 && echo "[*] Downloading s6-overlay version v${S6_VER} from github" \
 && cd /tmp && wget -q https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] Installing s6-overlay" \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
 && rm -f /tmp/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] Cleaning" \
 && apk del curl \
 && rm -rf /var/cache/apk/* /tmp/* \
 && echo \
 && echo "[*] Creating \"rtorrent\" user" \
 && addgroup -g ${GID} rtorrent \
 && adduser -S -D -u ${UID} -g rtorrent --home=${RTORRENT_HOME} rtorrent \
 && echo \
 && echo "[*] Applying rights" \
 && cd /app/rtorrent \
 && mkdir -p download config session log watch \
 && chmod a+r rtorrent.rc \
 && chmod a+rw /app/flood/config.js \
 && find /app/ \! -user rtorrent -exec chown rtorrent:rtorrent {} \;

VOLUME /app/flood/flood-db /app/rtorrent/download /app/rtorrent/config /app/rtorrent/log /app/rtorrent/watch

EXPOSE 3000 49184 49184/udp

LABEL description="rTorrent with WebUI front-end" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
