#!/usr/bin/env bash

. includes.sh

F_DRAW_START

F_DRAW_OUT "Starting the \033[036mTraefik\033[0m container with the \033[93m${V_ENV}\033[0m environment"

F_DRAW_RULER

for V_FILE in "traefik_dynamic_test.toml" "traefik_dynamic_web.toml" "traefik_test.toml" "traefik_web.toml"; do
    if [[ ! -f "$V_ROOT/conf/$V_FILE" ]]; then
        F_DRAW_OUT "\033[031mError: file $V_ROOT/conf/$V_FILE not found.\033[0m"
        F_DRAW_OUT "\033[031mPlease copy $V_ROOT/conf/${V_FILE}.example to $V_ROOT/conf/$V_FILE\033[0m"
        F_DRAW_OUT "\033[031mand make the necessary adjustments.\033[0m"
        F_DRAW_END
        exit 1
    fi
done

if [[ "$V_ENV" == "web" && ! -f "$V_ROOT/conf/acme.json" ]]; then
    F_DRAW_OUT "Creating \033[036mconf/acme.json\033[0m"
    touch "$V_ROOT/conf/acme.json"
    if [[ ! -f "$V_ROOT/conf/acme.json" ]]; then
        F_DRAW_BREAK
        F_DRAW_OUT "\033[031mError: creating $V_ROOT/conf/acme.json failed, aborting\033[0m"
        F_DRAW_END
        exit 1
    fi
    chmod 0600 "$V_ROOT/conf/acme.json"
    ls -la --color "$V_ROOT/conf"| grep --color=always "acme.json"
    F_DRAW_RULER
fi

F_DRAW_OUT "Current \033[036mTraefik\033[0m containers"
docker ps -a | grep --color=always "traefik"

F_DRAW_RULER

F_DRAW_OUT "Creating the Docker \033[036mweb\033[0m network"
docker network create web

F_DRAW_RULER

F_DRAW_OUT "Starting the \033[036mTraefik\033[0m container"
docker compose up "traefik" -d
docker ps -a | grep "traefik"

F_DRAW_RULER

F_DRAW_OUT "Current \033[036mTraefik\033[0m containers after start"
docker ps -a | grep --color=always "traefik"

F_DRAW_END

exit 0
