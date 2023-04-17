#!/usr/bin/env bash

V_ROOT=$( dirname $( readlink -f "$0" ) )
if [[ -f $V_ROOT/.env ]]; then
    . $V_ROOT/.env
fi

V_ENV=${ENVIRONMENT:-web}
if [[ "$V_ENV" == "" ]]; then
    V_ENV="web"
fi

echo
echo -e "\033[036m┌─────────────────────────────────────────────────────────────────────────────\033[0m"

echo -e "\033[036m│\033[0m"
echo -e "\033[036m│\033[0m Starting the \033[036mTraefik\033[0m container with the \033[93m${V_ENV}\033[0m environment"
echo -e "\033[036m│\033[0m"

if [[ "$V_ENV" == "web" && ! -f "$V_ROOT/conf/acme.json" ]]; then
    echo -e "\033[036m│\033[0m Creating \033[036mconf/acme.json\033[0m"
    touch "$V_ROOT/conf/acme.json"
    if [[ ! -f "$V_ROOT/conf/acme.json" ]]; then
        echo -e "\033[036m│\033[0m"
        echo -e "\033[036m│\033[0m \033[031mError: creating $V_ROOT/conf/acme.json failed, aborting\033[0m"
        echo -e "\033[036m│\033[0m"
        echo -e "\033[036m└─────────────────────────────────────────────────────────────────────────────\033[0m"
        exit 1
    fi
    chmod 0600 "$V_ROOT/conf/acme.json"
    ls -la --color "$V_ROOT/conf"| grep --color=always "acme.json"
    echo -e "\033[036m│\033[0m"
    echo -e "\033[036m├─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo -e "\033[036m│\033[0m"
fi

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"

echo -e "\033[036m│\033[0m"
echo -e "\033[036m├─────────────────────────────────────────────────────────────────────────────\033[0m"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Creating the Docker \033[036mweb\033[0m network"
docker network create web

echo -e "\033[036m│\033[0m"
echo -e "\033[036m├─────────────────────────────────────────────────────────────────────────────\033[0m"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Starting the \033[036mTraefik\033[0m container"
docker compose up "traefik" -d
docker ps -a | grep "traefik"

echo -e "\033[036m│\033[0m"
echo -e "\033[036m├─────────────────────────────────────────────────────────────────────────────\033[0m"
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Current \033[036mTraefik\033[0m containers after start"
docker ps -a | grep --color=always "traefik"

echo -e "\033[036m│\033[0m"
echo -e "\033[036m└─────────────────────────────────────────────────────────────────────────────\033[0m"
echo

exit 0
