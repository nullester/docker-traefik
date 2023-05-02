#!/usr/bin/env bash

V_ROOT=$( dirname $( readlink -f "$0" ) )
if [[ -f $V_ROOT/.env ]]; then
    . $V_ROOT/.env
fi
V_ENV=${ENVIRONMENT:-web}
if [[ "$V_ENV" == "" ]]; then
    V_ENV="web"
fi

function F_TFK_TRAP() {
    local V_MSG="$1"
    echo
    F_TFK_DRAW_BREAK
    if [[ -n "V_MSG" ]]; then
        F_TFK_DRAW_OUT "\033[031mAborted\033[0m"
    else
        F_TFK_DRAW_OUT "\033[031m${V_MSG}\033[0m"
    fi
    F_TFK_DRAW_END
    exit 1
}

trap F_TFK_TRAP SIGINT

function F_TFK_DRAW_START() {
    echo
    echo -e "\033[036m┌─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo -e "\033[036m│\033[0m"
}

function F_TFK_DRAW_BREAK() {
    echo -e "\033[036m│\033[0m"
}

function F_TFK_DRAW_RULER() {
    echo -e "\033[036m│\033[0m"
    echo -e "\033[036m├─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo -e "\033[036m│\033[0m"
}

function F_TFK_DRAW_END() {
    echo -e "\033[036m│\033[0m"
    echo -e "\033[036m└─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo
}

function F_TFK_DRAW_OUT() {
    echo -e "\033[036m│\033[0m $1"
}
