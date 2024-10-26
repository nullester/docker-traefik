#!/usr/bin/env bash

V_ROOT=$( dirname $( readlink -f "$0" ) )

echo -e "Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"
echo
echo -e "Stopping \033[036mTraefik\033[0m containers"
docker stop $( docker ps -a | grep "traefik" | awk '{print $1}' )
echo
echo -e "Current \033[036mTraefik\033[0m containers after stop"
docker ps -a | grep --color=always "traefik"
echo
echo -e "Removing \033[036mTraefik\033[0m containers"
docker rm $( docker ps -a -f status=exited -f status=created | grep "traefik" | awk '{print $1}' )
echo
echo "Current \033[036mTraefik\033[0m containers after remove"
docker ps -a | grep --color=always "traefik"

exit 0