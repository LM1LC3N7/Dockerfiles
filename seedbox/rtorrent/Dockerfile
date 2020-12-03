FROM alpine:latest

ENV S6_FIX_ATTRS_HIDDEN=1 \
   RTORRENT_HOME=/app/rtorrent \
   UID=9991 \
   GID=9991 \
   TERM=xterm

COPY rootfs /

RUN echo \
 && echo "[*] Updating OS" \
 && apk -U upgrade \
 && echo \
 && echo "[*] Installing rtorrent last version from edge repository" \
 && apk add rtorrent mediainfo \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
 && echo \
 && echo "[*] Installing dependencies" \
 && apk add --no-cache \
    curl wget \
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
 && apk del curl wget \
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
 && find /app/ \! -user rtorrent -exec chown rtorrent:rtorrent {} \;

VOLUME /app/rtorrent/download /app/rtorrent/config /app/rtorrent/log /app/rtorrent/watch

#EXPOSE 3000 49184 49184/udp
EXPOSE 5000

LABEL description="rTorrent in last version based on alpine" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
