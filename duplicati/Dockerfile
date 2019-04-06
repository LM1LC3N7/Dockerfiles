FROM mono:5-slim

ENV S6_FIX_ATTRS_HIDDEN=1 \
   UID=991 \
   GID=991 \
   DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN echo \
 && echo "[*] Updating OS" \
 && apt-get -yq update \
 && echo \
 && echo "[*] Installing dependencies" \
 && apt-get install -yq \
            bzip2 \
            curl \
            wget \
            mediainfo \
            mono-devel \
            mono-vbnc \
            sqlite3 \
            unzip \
 && echo \
 && echo "[*] Searching the last release version of duplicati from GitHub" \
 && VER=$(curl -s https://api.github.com/repos/duplicati/duplicati/releases | grep tag_name | head -n 1 | awk '{print $2}') \
 && VER="${VER:1}" && VER="${VER::-2}" && VER_ZIP=${VER:1} && VER_ZIP=${VER_ZIP#*-} \
 && echo \
 && echo "[*] Downloading duplicati version ${VER} from github" \
 && cd /tmp \
 && wget -q https://github.com/duplicati/duplicati/releases/download/${VER}/duplicati-${VER_ZIP}.zip \
 && echo \
 && echo "[*] Installing Duplicati" \
 && unzip -qq /tmp/duplicati-${VER_ZIP}.zip -d /duplicati \
 && echo \
 && echo "[*] Searching the last release version of s6-overlay from GitHub" \
 && S6_VER=$(curl --silent "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
 && echo \
 && echo "[*] Downloading s6-overlay version ${S6_VER} from github" \
 && cd /tmp && wget -q https://github.com/just-containers/s6-overlay/releases/download/${S6_VER}/s6-overlay-amd64.tar.gz \
 && echo \
 && echo "[*] Adding \"app\" user" \
 && groupadd --gid $GID app \
 && useradd -g app -u ${UID} -d /config app
 && chown -R app:app /config \
 && echo \
 && echo "[*] Cleaning" \
 && apt-get clean && rm -fr /var/lib/apt/list/* /tmp/*

COPY rootfs/run /etc/services.d/duplicati/

VOLUME /backups /restore /config

EXPOSE 8200

LABEL description="Duplicati in last version based on mono:5-slim (debian)" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
