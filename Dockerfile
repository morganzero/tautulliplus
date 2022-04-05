FROM ghcr.io/linuxserver/baseimage-alpine:3.15

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ENV TAUTULLI_DOCKER=True
LABEL maintainer="sushibox.io"

RUN \
  apk --quiet --no-cache --no-progress update && apk --quiet --no-cache --no-progress upgrade && \
  apk add -U --update --no-cache --virtual=build-dependencies g++ gcc make py3-pip python3-dev && \
  apk add -U --update --no-cache curl tar jq py3-openssl py3-setuptools python3 git && \
  python3 -m pip install --upgrade pip && pip3 install --no-cache-dir -U mock tzlocal plexapi cherrypy pycryptodomex && \
  mkdir -p /app/tautulli && curl -fsSL "https://github.com/zSeriesGuy/Tautulli/archive/v4.1.07.tar.gz" | tar xzf - -C /config --strip-components=1 && \
  echo "v4.1.07" > /app/tautulli/version.txt && echo "master" > /app/tautulli/branch.txt && \
  apk del --purge build-dependencies && apk del --quiet --clean-protected --no-progress && rm -f /var/cache/apk/*

COPY . .

VOLUME /config
EXPOSE 8181

CMD [ "python3", "Tautulli.py", "--datadir", "/config" ]
# HEALTHCHECK --start-period=90s CMD curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1
