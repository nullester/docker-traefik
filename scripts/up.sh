#!/usr/bin/env bash

. "$( dirname $( readlink -f "$0" ) )/bootstrap.sh"

F_TFK_DRAW_START

F_TFK_VERIFY_ENV
F_TFK_VERIFY_ACME
F_TFK_VERIFY_TOMLS

F_TFK_DRAW_OUT "Starting the \033[036mTraefik\033[0m container with the \033[031m${V_TFK_ENV}\033[0m environment"
F_TFK_DRAW_RULER

F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"

F_TFK_DRAW_RULER

F_TFK_DRAW_OUT "Creating the Docker \033[036mweb\033[0m network"
docker network create web

F_TFK_DRAW_RULER

F_TFK_DRAW_OUT "Starting the \033[036mTraefik\033[0m container"
docker compose  -f "${V_TFK_ROOT}/docker-compose.yml" up "traefik" -d
docker ps -a | grep "traefik"

F_TFK_DRAW_RULER

F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m containers after start"
docker ps -a | grep --color=always "traefik"

F_TFK_DRAW_END

exit 0
