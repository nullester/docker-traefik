#!/usr/bin/env bash

if [[ ! -f acme.json ]]; then
    touch acme.json
    chmod 0600 acme.json
fi

docker network create web

docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $PWD/traefik_dynamic.toml:/traefik_dynamic.toml \
  -v $PWD/acme.json:/acme.json \
  -p 80:80 \
  -p 443:443 \
  --network web \
  --name traefik \
  traefik:v2.3

docker ps -a | grep "traefik"

exit 0
