#!/usr/bin/env bash

V_ROOT=$( dirname $( readlink -f "$0" ) )
if [[ -f $V_ROOT/.env ]]; then
    . $V_ROOT/.env
fi

echo -e "\033[036m│\033[0m"
echo -e "\033[036m│\033[0m Starting the \033[036mTraefik\033[0m container"
echo -e "\033[036m│\033[0m"

if [[ ! -f acme.json ]]; then
    echo -e "\033[036m│\033[0m Creating \033[036macme.json\033[0m"
    touch acme.json
    chmod 0600 acme.json
    ls -la --color | grep --color=always "acme.json"
    echo -e "\033[036m│\033[0m"
fi

echo -e "\033[036m│\033[0m Creating the Docker \033[036mweb\033[0m network"
docker network create web
echo -e "\033[036m│\033[0m"

echo -e "\033[036m│\033[0m Starting the \033[036mTraefik\033[0m container"
docker compose up traefik -d
docker ps -a | grep "traefik"
echo -e "\033[036m│\033[0m"

exit 0
