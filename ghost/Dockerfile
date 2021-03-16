#
# Multi-stage Dockerfile
#


#
# Stage 1:
# ----- Building ghost -----
#

FROM node:12-buster as build

# https://github.com/TryGhost/Ghost/releases
ENV GHOST_VER=3.37.1

RUN echo \
 && echo "[*] Installing ghost dependencies" \
 && apt-get update && apt-get install -y \
    python curl gcc make git zip unzip bash

SHELL ["/bin/bash", "-c"]

RUN echo \
 && echo "[*] Searching the last release version of ghost from GitHub" \
 && GHOST_VER_OLD=$(curl --silent "https://api.github.com/repos/TryGhost/Ghost/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
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
 && mv /ghost/content/themes/Casper-${CASPER_VER} /ghost/content/themes/casper \
 && echo \
 && echo "[*] Searching the last release version of the caffeine theme from GitHub" \
 && CAFFEINE_VER=$(curl --silent "https://api.github.com/repos/kelyvin/caffeine-theme/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading caffeine theme version ${CAFFEINE_VER} from github" \
 && cd /tmp && wget -q https://github.com/kelyvin/caffeine-theme/releases/download/${CAFFEINE_VER}/caffeine-theme-${CAFFEINE_VER}.zip \
 && echo \
 && echo "[*] Installing caffeine theme" \
 && unzip -q /tmp/caffeine-theme-${CAFFEINE_VER}.zip -d /tmp/ \
 && mv caffeine-theme-${CAFFEINE_VER} /ghost/content/themes/ \
 && rm -rf /tmp/* \
 && echo \
 && echo "[*] ----- FIRST STAGE FINISHED -----" \
 && echo \
 && echo "[*] Importing files from first docker build stage to second" \
 && echo


#
# Stage 2:
# ----- Creating final image -----
#
# Based on Node.js v10.16.3 (on april, 16)
# https://github.com/GoogleContainerTools/distroless/blob/master/experimental/nodejs/README.md
FROM gcr.io/distroless/nodejs:12

ENV HOME=/ghost \
    NODE_ENV=production

COPY --from=build /ghost /ghost
COPY --from=build /tmp /tmp

WORKDIR /ghost

VOLUME /ghost/content

EXPOSE 2368

LABEL description="Ghost blog on distroless" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

#HEALTHCHECK --interval=1m --timeout=3s \
#  CMD curl -f http://localhost:2368/ || exit 1

CMD ["index"]
