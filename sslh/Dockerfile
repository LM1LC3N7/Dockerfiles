FROM alpine:3.9

ENV LISTEN_IP=0.0.0.0 \
    LISTEN_PORT=443 \
    SSH_HOST=localhost \
    SSH_PORT=22 \
    OPENVPN_HOST=localhost \
    OPENVPN_PORT=1194 \
    HTTPS_HOST=localhost \
    HTTPS_PORT=8443 \
    SHADOWSOCKS_HOST=localhost \
    SHADOWSOCKS_PORT=8388

RUN echo \
 && echo "[*] Updating OS" \
 && apk -U upgrade \
 && echo \
 && echo "[*] Installing sslh last version from edge testing repository" \
 && apk add sslh \
    --repository=http://dl-3.alpinelinux.org/alpine/edge/testing/ \
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
 && echo "[*] Creating \"app\" user" \
 && addgroup -g 991 app \
 && adduser -S -D -u 991 -g app app

COPY /rootfs/run /etc/services.d/sslh/run

EXPOSE 443/tcp

LABEL description="SSLH in last version based on alpine" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
