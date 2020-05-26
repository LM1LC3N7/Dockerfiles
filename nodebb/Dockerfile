# Help Sources:
#   - https://github.com/NodeBB/NodeBB
#   - https://docs.nodebb.org/
#   - https://github.com/benchpressjs/benchpressjs/blob/master/README.md#manually-building-native-module
#     > The rust native module template compiler is approximately 30 times faster than the Javascript-based compiler.
#   - https://github.com/nilsramsperger/docker-nodebb/blob/master/Dockerfile


#
# Multi-stage Dockerfile
#


#
# Stage 1:
# ----- Building NodeBB -----
#

FROM node:12-alpine as build

ENV NODE_ENV=production \
    HOME=/nodebb

WORKDIR /nodebb

RUN echo \
 && echo "[*] Installing build dependencies" \
 && apk update && apk upgrade \
 && apk add \
    make \
    build-base \
    git \
    curl \
    wget \
    sed \
    python \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update \
 && apk upgrade \
 && apk add gcc musl-dev rust cargo \
 && echo \
 && echo "[*] Creating \"nodebb\" user" \
 && addgroup -g 991 nodebb \
 && adduser -S -D -u 991 -g nodebb nodebb \
 && chown -R nodebb:nodebb /nodebb \
 && echo \
 && echo "[*] Searching the last version of s6-overlay" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && S6_VER="${S6_VER:1}" \
 && echo \
 && echo "[*] Downloading s6-overlay version v${S6_VER} from github" \
 && cd /tmp && wget -q https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] Installing s6-overlay" \
 && mkdir /tmp/overlay \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /tmp/overlay \
 && echo \
 && echo "[*] Installing Neon (dependency)" \
 && curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y \
 && PATH=/nodebb/.cargo/bin:$PATH \
 && npm install --global neon-cli \
 && chown -R nodebb:nodebb /nodebb 

# Installing NodeBB dependencies as normal user, not root
USER nodebb

COPY --chown=nodebb:nodebb rootfs/etc/nodebb/active-plugins /etc/nodebb/active-plugins

RUN echo \
 && echo "[*] Cloning NodeBB" \
 && git clone https://github.com/NodeBB/NodeBB.git nodebb && cd nodebb \
 && cp install/package.json package.json \
 && echo \
 && echo "[*] Installing NodeBB dependencies" \
 && npm install --only=prod \
 && echo \
 && echo "[*] Installing NodeBB plugins" \
 && while read plugin ; do echo ; echo "  [*] Installing ${plugin}" ; npm install ${plugin} ; done < /etc/nodebb/active-plugins \
 && npm cache clean --force


#
# Stage 2:
# ----- Creating final image -----
#
FROM node:12-alpine

ENV NODE_ENV=production \
    HOME=/nodebb \
    daemon=false \
    silent=false

WORKDIR /nodebb

RUN echo \
  && echo "[*] Upgrading Alpine" \
  && apk upgrade --no-cache\
  && echo \
  && echo "[*] Creating \"nodebb\" user" \
  && addgroup -g 991 nodebb \
  && adduser -S -D -u 991 -g nodebb nodebb \
  && mkdir /nodebb/logs \
  && chown -R nodebb:nodebb /nodebb

COPY --from=build /tmp/overlay /
COPY --chown=nodebb:nodebb --from=build /nodebb/nodebb /nodebb

COPY rootfs/etc /etc
COPY --chown=nodebb:nodebb rootfs/nodebb /nodebb

VOLUME /nodebb/public/uploads /etc/nodebb

EXPOSE 4567

LABEL description="NodeBB forum running on alpine and distroless" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
