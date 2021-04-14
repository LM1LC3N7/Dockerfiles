# Help Sources:
#   - https://github.com/NodeBB/NodeBB
#   - https://docs.nodebb.org/
#   - https://github.com/benchpressjs/benchpressjs/blob/master/README.md#manually-building-native-module
#     > The rust native module template compiler is approximately 30 times faster than the Javascript-based compiler.
#   - https://github.com/nilsramsperger/docker-nodebb/blob/master/Dockerfile

FROM node:14-alpine

ENV NODE_ENV=production \
    HOME=/nodebb

WORKDIR /nodebb

COPY rootfs/etc/nodebb/active-plugins /tmp/active-plugins

RUN echo \
 && echo "[*] Installing build dependencies" \
 && apk update && apk upgrade \
 && apk add \
    bash \
    imagemagick \
    openssl \
    icu \
 && apk add -t TMP build-base \
                   git \
                   curl \
                   wget \
                   sed \
                   python \
                   tar \
                   icu-dev \
                   openssl-dev \
                   pngcrush optipng \
                   zip \
 && echo \
 && echo "[*] Creating \"nodebb\" user" \
 && addgroup -g 9991 nodebb \
 && adduser -S -D -u 9991 -G nodebb nodebb \
 && chown -R nodebb:nodebb /nodebb \
 && echo \
 && echo "[*] Searching the last release version of s6-overlay from GitHub" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading s6-overlay version ${S6_VER} from github" \
 && cd /tmp && wget -q https://github.com/just-containers/s6-overlay/releases/download/${S6_VER}/s6-overlay-amd64-installer \
 && echo \
 && echo "[*] Installing s6-overlay" \
 && chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer / \
 && echo \
 && echo "[*] Searching the last release version of NodeBB from GitHub" \
 && NODEBB_VER=$(curl --silent "https://api.github.com/repos/NodeBB/NodeBB/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading NodeBB release version ${NODEBB_VER} from github" \
 && cd /tmp && wget -q https://github.com/NodeBB/NodeBB/archive/refs/tags/${NODEBB_VER}.zip \
 && echo \
 && echo "[*] Installing NodeBB" \
 && unzip -qq /tmp/${NODEBB_VER}.zip -d /tmp/nodebb && echo && ls -alh && cd nodebb &&  pwd && ls -alh \
 && rm -rf /nodebb/.wget* \
 && mv /tmp/nodebb/NodeBB-*/* /nodebb \
 && cd /nodebb && echo && echo && ls -alh && echo && echo \
 && echo \
 && echo "[*] Installing NodeBB" \
 && ./nodebb setup \
 && echo \
 && echo "[*] Installing NodeBB plugins" \
 && while read plugin ; do echo ; echo "  [*] Installing ${plugin}" ; npm install ${plugin} ; done < /tmp/active-plugins \
 && rm /tmp/active-plugins \
 && npm cache clean --force \
 && echo \
 && echo "[*] Cleaning build apps." \
 && apk del TMP \
 && rm -rf /tmp/npm* \
          /var/cache/apk/* \
          /tmp/* \
 && echo \
 && echo "[*] Applying permissions for NodeBB user on /nodebb." \
 && find /nodebb \! -user nodebb -exec chown nodebb:nodebb {} \; \
 && find /nodebb \! -group nodebb -exec chown nodebb:nodebb {} \;

COPY --chown=nodebb:nodebb rootfs/nodebb /nodebb
COPY rootfs/etc /etc

VOLUME /nodebb/public/uploads /etc/nodebb

EXPOSE 4567

LABEL description="NodeBB forum running on alpine." \
      maintainer="Louis MILCENT <github@milcent.co>"

ENTRYPOINT ["/init"]
