# Sources:
# https://github.com/goofball222/pritunl
# https://github.com/cloudkite-io/pritunl-docker

FROM alpine:3.10

LABEL author="Louis MILCENT"

ARG VERSION=1.29.2276.91

ENV \
    DEBUG=false \
    GOPATH="/go" \
    GOCACHE="/tmp/gocache" \
    REVERSE_PROXY=true \
    SERVER_PORT=9700 \
    SERVER_SSL=true \
    PRITUNL_OPTS="" \
    MONGODB_URI="mongodb://pritunl-db:27017/pritunl"

WORKDIR /opt/pritunl

ADD root /

RUN set -x \
  && echo "[*] Installing dependencies" \
  && apk --no-cache add --update go git bzr wget curl py2-pip \ 
    gcc python python-dev make musl-dev linux-headers libffi-dev openssl-dev \
    py-setuptools openssl procps ca-certificates openvpn bash \
  && pip install --upgrade pip \
  #
  # Pritunl Install
  #
  && echo "[*] Searching the last version of pritunl on GitHub" \
  && PRITUNL_VER=$(curl --silent "https://api.github.com/repos/pritunl/pritunl/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
  && echo "[*] Installing pritunl web & dns modules" \
  && go get github.com/pritunl/pritunl-dns \
  && go get github.com/pritunl/pritunl-web \
  && cp /go/bin/* /usr/bin/ \
  && echo "[*] Downloading Pritunl version v${PRITUNL_VER} from github" \
  && wget https://github.com/pritunl/pritunl/archive/${PRITUNL_VER}.tar.gz \
  && tar zxvf ${PRITUNL_VER}.tar.gz \
  && cd pritunl-${PRITUNL_VER} \
  && echo "[*] Installing pyton modules" \
  && python setup.py build \
  && pip install -r requirements.txt \
  && python2 setup.py install \
  && cd .. \
  && rm -rf *${PRITUNL_VER}* \
  && rm -f *.tar.gz \
  && rm -rf /tmp/* /var/cache/apk/* /go /root/.cache/* \
  && echo "[*] Updating openssl configuration" \
  && sed -i -e '/^attributes/a prompt\t\t\t= yes' /etc/ssl/openssl.cnf \
  && sed -i -e '/countryName_max/a countryName_value\t\t= FR' /etc/ssl/openssl.cnf

EXPOSE 80/tcp 443/tcp 443/udp 1194/tcp 1194/udp 9700/tcp

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["pritunl"]

