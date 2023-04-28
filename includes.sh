#!/usr/bin/env bash

# V_ROOT=$( dirname $( readlink -f "$0" ) ) # @todo: doesn't work on Mac
V_ROOT="."
if [[ -f $V_ROOT/.env ]]; then . $V_ROOT/.env; fi
V_ENV=${ENVIRONMENT:-web}
if [[ "$V_ENV" == "" ]]; then V_ENV="web"; fi

function F_DRAW_START() {
    echo
    echo -e "\033[036m┌─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo -e "\033[036m│\033[0m"
}

function F_DRAW_BREAK() {
    echo -e "\033[036m│\033[0m"
}

function F_DRAW_RULER() {
    echo -e "\033[036m│\033[0m"
    echo -e "\033[036m├─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo -e "\033[036m│\033[0m"
}

function F_DRAW_END() {
    echo -e "\033[036m│\033[0m"
    echo -e "\033[036m└─────────────────────────────────────────────────────────────────────────────\033[0m"
    echo
}

function F_DRAW_OUT() {
    echo -e "\033[036m│\033[0m $1"
}
