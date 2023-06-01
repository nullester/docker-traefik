#!/usr/bin/env bash

. "$( dirname $( readlink -f "$0" ) )/includes.sh"

F_TFK_DRAW_START

F_TFK_VERIFY_ENV; F_TFK_VERIFY_ACME; F_TFK_VERIFY_TOMLS

F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"

F_TFK_DRAW_RULER

F_TFK_DRAW_OUT "Stopping \033[036mTraefik\033[0m containers"
docker stop $( docker ps -a | grep "traefik" | awk '{print $1}' )
F_TFK_DRAW_BREAK
F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m containers after stop"
docker ps -a | grep --color=always "traefik"

F_TFK_DRAW_RULER

F_TFK_DRAW_OUT "Removing \033[036mTraefik\033[0m containers"
docker rm $( docker ps -a -f status=exited -f status=created | grep "traefik" | awk '{print $1}' )
F_TFK_DRAW_BREAK
F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m containers after remove"
docker ps -a | grep --color=always "traefik"

if [[ $( F_TFK_BOOL "$V_TFK_IMAGES_CLEANUP" ) -eq 1 ]]; then

    F_TFK_DRAW_RULER

    F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m images"
    docker image ls | grep --color=always "traefik"

    F_TFK_DRAW_RULER

    F_TFK_DRAW_OUT "Removing \033[036mTraefik\033[0m images"
    docker rmi $( docker image ls | grep --color=always "traefik" | awk '{print $3}' )
    F_TFK_DRAW_BREAK
    F_TFK_DRAW_OUT "Current \033[036mTraefik\033[0m images after remove"
    docker image ls | grep --color=always "traefik"

fi

F_TFK_DRAW_END

exit 0
