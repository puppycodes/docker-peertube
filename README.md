# Peertube for Docker

[![Docker hub](https://img.shields.io/docker/automated/tedomum/peertube.svg?maxAge=2592000)](https://hub.docker.com/r/tedomum/peertube/)

Peertube is a federated video sharing and distribution solution, based on a
Web application and Webtorrent for efficient download.

This Docker image is meant to be quite lightweight and only embeds Peertube
itself. We recommend setting it behind a reverse proxy (see traefik or
jwilder/nginx-proxy for a great dynamic reverse proxy).

## Volumes

The container uses a single volume located at ``/data`` to store:

 - videos
 - resized media
 - thumbnails
 - certificates if any

The contents of the mounted path must belong to ``991:991``.

# Ports

The container exposes its Web interface port ``9000/tcp``. All services are
exposed through the Web interface.

# Configuration

Configuration is passed through environment variables.

Reverse proxy configuration :

 - ``PUBLIC_HOSTNAME`` must be set to the public hostname of this instance
   (the one served by the reverse proxy)
 - ``PUBLIC_PORT`` must be set to the TCP port where the instance publicly
   served (defaults to ``80``)
 - ``PUBLIC_HTTPS`` must be set if the reverse proxy serves HTTPS

Database configuration :

  - ``PG_HOST`` should be set to the database hostname (defaults to ``db``)
  - ``PG_PORT`` can be set to the database port (defaults to ``5432``)
  - ``PG_USERNAME`` must be set to the database username (defaults to ``peertube``)
  - ``PG_PASSWORD`` must be set to the database password.

Note that the database must be named ``peertube`` (this is somehow currently
hardcoded in peertube).

Application configuration :

  - ``ADMIN_EMAIL`` must be set to a contact email address for the instance
    administrator
  - ``TRANSCODING`` can be set to enable transcoding of videos to alternate
    formats (uses more disk space and CPU while uploading)
  - ``VIDEO_QUOTA`` can be set in bytes to enable a video upload quota per
    user
  - ``SIGNUP_LIMIT`` can be set to the maximum number of signed up users on
    the instance

## Example Docker Compose

The following Docker Compose file uses a Docker postgres server and set the
proper flags to expose peertube over traefik.

```
version: '3'

services:
  peertube:
    image: tedomum/peertube
    labels:
      - traefik.enable=true
      - traefik.frontend.rule=Host:my.host.tld
      - traefik.port=9000
    volumes:
      - ./data:/data
    environment:
      - PUBLIC_HOSTNAME=my.host.tld
      - PUBLIC_PORT=443
      - PUBLIC_HTTPS=true
      - ADMIN_EMAIL=admin@host.tld
      - PG_HOST=db
      - PG_USER=peertube
      - PG_PASSWORD=changeme
    logging:
      driver: "json-file"

  db:
    image: postgres:latest
    volumes:
      - ./db:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=peertube
      - POSTGRES_PASSWORD=changeme

```
