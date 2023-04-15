#!/usr/bin/env bash

V_ROOT=$( dirname $( readlink -f "$0" ) )
if [[ -f $V_ROOT/.env ]]; then
    . $V_ROOT/.env
fi

echo -e "\033[036m│\033[0m"
echo -e "\033[036m│\033[0m Stopping all \033[036mTraefik\033[0m containers"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"
echo -e "\033[036m│\033[0m"

docker stop $( docker ps -a | grep "traefik" | awk '{print $1}' )
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m containers after stop"
docker ps -a | grep --color=always "traefik"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Removing \033[036mTraefik\033[0m containers"
docker rm $( docker ps -a -f status=exited -f status=created | grep "traefik" | awk '{print $1}' )
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m containers after remove"
docker ps -a | grep --color=always "traefik"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m images"
docker image ls | grep --color=always "traefik"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Removing \033[036mTraefik\033[0m images"
docker rmi $( docker image ls | grep --color=always "traefik" | awk '{print $3}' )
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m images after remove"
docker image ls | grep --color=always "traefik"
echo -e "\033[036m│\033[0m"

exit 0
