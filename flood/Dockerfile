#
# Multi-stage Dockerfile
#


#
# Stage 1:
# ----- Building flood -----
#

FROM node:8.15.0 as flood-build

COPY assets//config.js /app/flood/config.js

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
 && mkdir -p /app/flood && cd /app/flood \
 && mv /app/flood/config.js /tmp \
 && git clone https://github.com/jfurrow/flood.git . \
 && mv /tmp/config.js /app/flood \
 && npm install \
 && echo \
 && echo "[*] Building flood assets" \
 && npm run build \
 && npm prune --production \
 && npm cache clean --force


#
# Stage 2:
# ----- Creating final image -----
#
FROM gcr.io/distroless/nodejs

ENV HOME=/app/flood

COPY --from=flood-build /app/flood /app/flood
COPY --from=flood-build /usr/bin/curl /usr/bin/curl

WORKDIR /app/flood

VOLUME /app/flood/flood-db

EXPOSE 3000

LABEL description="flood interface for rTorrent running on distroless" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

CMD ["server/bin/start.js"]
