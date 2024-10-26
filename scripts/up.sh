#!/usr/bin/env bash

V_ROOT=$( dirname $( readlink -f "$0" ) )

echo -e "Starting the \033[036mTraefik\033[0m container"
echo
echo -e "Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"
echo
echo -e "Creating the Docker web network"
docker network create web
echo
echo -e "Starting the \033[036mTraefik\033[0m container"
docker compose -f "${V_ROOT}/docker-compose.yml" up -d
docker ps -a | grep "traefik"
echo
echo -e "Current \033[036mTraefik\033[0m containers after start"
docker ps -a | grep --color=always "traefik"

exit 0
