#
# Stage 1:
# ----- Building flood -----
#

FROM node:12-buster as build

COPY rootfs/app/flood/config.js /app/flood/config.js
WORKDIR /app/flood
ENV HOME=/app/flood
SHELL ["/bin/bash", "-c"]

RUN echo \
 && echo "[*] Installing flood dependencies" \
 && apt-get update && apt-get install -y \
    python \
    make \
    g++ \
    git \
    curl \
    tar \
 && echo \
 && echo "[*] Installing flood" \
 && echo \
 && cd /app/flood && mv config.js /tmp  \
 && git clone https://github.com/jfurrow/flood.git . \
 && mv /tmp/config.js /app/flood \
 && npm ci && npm update \
 && echo \
 && echo "[*] Building flood assets" \
 && npm run build \
 && npm prune --production \
 && npm cache clean --force \
 && echo \
 && echo "[*] Searching the last version of s6-overlay" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && S6_VER="${S6_VER:1}" \
 && echo \
 && echo "[*] Downloading s6-overlay version v${S6_VER} from github" \
 && wget -q https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz

#
# Stage 2:
# ----- Creating final image -----
#
FROM node:12-alpine

COPY rootfs /
COPY --from=build --chown=9991:9991 /app/flood /app/flood

RUN echo \
 && echo "[*] Creating flood user." \
 && adduser --uid 9991 flood flood --disabled-password \
 && echo "[*] Installing s6-overlay" \
 && tar xzf /app/flood/s6-overlay-amd64.tar.gz -C / \
 && rm -rf /app/flood/s6-overlay-amd64.tar.gz \
 && echo "[*] Applying permissions." \
 && chown flood:flood /app /app/flood \
 && chmod ug+rwx /app /app/flood \
 && find /app/flood -type d -not -perm 0770 -exec chmod 0770 {} \; \
 && find /app/flood -type f -not -perm 0660 -exec chmod 0660 {} \;
 
VOLUME /app/flood/flood-db

EXPOSE 3000

LABEL description="flood interface for rTorrent running on distroless" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
