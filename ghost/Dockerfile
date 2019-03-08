#
# Multi-stage Dockerfile
#


#
# Stage 1:
# ----- Building ghost -----
#

FROM node:10-alpine as ghost-build

RUN echo \
 && echo "[*] Installing ghost dependencies" \
 && apk add --no-cache \
    python curl gcc make git zip \
 && addgroup -g 991 ghost \
 && adduser -S -D -u 991 -g ghost --home=/ghost ghost \
 && chown ghost:ghost /ghost

USER ghost

RUN echo \
 && echo "[*] Searching the last release version of ghost from GitHub" \
 && GHOST_VER=$(curl --silent "https://api.github.com/repos/TryGhost/Ghost/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading Ghost version ${GHOST_VER} from github" \
 && cd /tmp && wget -q https://github.com/TryGhost/Ghost/releases/download/${GHOST_VER}/Ghost-${GHOST_VER}.zip \
 && echo \
 && echo "[*] Installing Ghost" \
 && unzip -qq /tmp/Ghost-${GHOST_VER}.zip -d /ghost \
 && cd /ghost \
 && echo \
 && echo "[*] Installing Ghost modules" \
 && npm install --production \
 && echo "[*] Searching the last release version of the Casper theme from GitHub" \
 && CASPER_VER=$(curl --silent "https://api.github.com/repos/TryGhost/Casper/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading Casper theme version ${CASPER_VER} from github" \
 && cd /tmp && wget -q https://github.com/TryGhost/Casper/archive/${CASPER_VER}.tar.gz \
 && echo \
 && echo "[*] Installing Casper theme" \
 && tar xzf /tmp/${CASPER_VER}.tar.gz -C /ghost/content/themes/ \
 && rm -f /tmp/${CASPER_VER}.tar.gz \
 && rm -rf /ghost/content/themes/casper \
 && mv /ghost/content/themes/Casper-${CASPER_VER:1} /ghost/content/themes/casper \
 && echo \
 && echo "[*] Searching the last release version of s6-overlay from GitHub" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading s6-overlay version ${S6_VER} from github" \
 && cd /tmp && wget -q https://github.com/just-containers/s6-overlay/releases/download/${S6_VER}/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] ----- FIRST STAGE FINISHED -----" \
 && echo \
 && echo "[*] Importing files (UID=991, GID=991) from first docker build stage to second" \
 && echo "NOTICE: It could be long as there is $(find /ghost -type f | wc -l) files, approx. 200Mio)." && echo


#
# Stage 2:
# ----- Creating final image -----
#
FROM node:10-alpine

COPY --chown=991:991 --from=ghost-build /ghost /ghost
COPY --from=ghost-build /tmp /tmp
COPY rootfs /

ENV S6_FIX_ATTRS_HIDDEN=1 \
    NODE_ENV=production \
    GHOST_URL=https://blog.lmilcent.com \
    GHOST_HOST=0.0.0.0 \
    GHOST_COMPRESS=true \
    GHOST_IMG_RESIZE=true \
    GHOST_LOG_LEVEL=debug

RUN echo \
 && echo "[*] Updating OS" \
 && apk -U upgrade \
 && echo \
 && echo "[*] Installing s6-overlay" \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
 && rm -f /tmp/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] Cleaning" \
 && rm -rf /var/cache/apk/* /tmp/* \
 && echo \
 && echo "[*] Creating \"ghost\" user" \
 && addgroup -g 991 ghost \
 && adduser -S -D -u 991 -g ghost --home=/ghost ghost \
 && echo \
 && echo "[*] Applying rights" \
 && echo "NOTICE: It could be long as there is $(find /ghost -type f | wc -l) files, approx. 340Mio)." \
 && cd /ghost/content \
 && cp ghost.conf /ghost/config.development.json \
 && cp ghost.conf /ghost/config.production.json \
 && find /ghost \! -user ghost -exec chown ghost:ghost {} \;

VOLUME /ghost/content

EXPOSE 2368

LABEL description="Ghost blog using s6-overlay" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
