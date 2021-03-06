FROM debian:10-slim

ENV S6_FIX_ATTRS_HIDDEN=1 \
   UID=8888 \
   GID=8888 \
   DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN echo \
 && echo "[*] Updating OS and installing tools" \
 && apt-get -yq update && apt-get -yq install wget curl \
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
 && echo "[*] Installing Duplicati dependencies" \
 && apt-get install -yq \
            bzip2 \
            sqlite3 \
            unzip \
            acl \
            apt-transport-https dirmngr gnupg ca-certificates ssh-askpass \
 && echo \
 && echo "[*] Installation last version of mono from official website" \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
 && apt update \
 && apt install mono-xsp4 -y \
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
 && echo "[*] Adding \"app\" user" \
 && groupadd --gid $GID app \
 && mkdir /config \
 && useradd -g app -u ${UID} -d /config app \
 && chown -R app:app /config \
 && echo \
 && echo "[*] Cleaning" \
 && apt-get clean && rm -fr /var/lib/apt/list/* /tmp/*

COPY rootfs/run /etc/services.d/duplicati/run
COPY rootfs/apply-backup-acl.sh /

# Volume to use
VOLUME /backups /restore /config

EXPOSE 8200

LABEL description="Duplicati in last version based on debian:10-slim" \
      maintainer="Louis MILCENT <louis@lmilcent.com>"

ENTRYPOINT ["/init"]
