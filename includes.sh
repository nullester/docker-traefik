#!/usr/bin/env bash

V_TFK_ROOT=$( dirname $( readlink -f "$0" ) )

function F_TFK_VERIFY_ENV() {
    if [[ -f "${V_TFK_ROOT}/.env" ]]; then
        . "${V_TFK_ROOT}/.env"
    fi
    V_TFK_ENV="$ENVIRONMENT"
    while [[ "$V_TFK_ENV" != "test" && "$V_TFK_ENV" != "web" ]]; do
        echo -e -n "\033[036m│\033[0m Invalid environment detected. Please enter \033[036mtest\033[0m or \033[036mweb\033[0m to use that one: \033[036m"
        local V_ENV=""
        read V_ENV
        echo -e -n "\033[0m"
        if [[ "$V_ENV" == "test" || "$V_ENV" == "web" ]]; then
            touch "${V_TFK_ROOT}/.env"
            echo "ENVIRONMENT=\"${V_ENV}\"" >> "${V_TFK_ROOT}/.env"
            . "${V_TFK_ROOT}/.env"
            V_TFK_ENV="$ENVIRONMENT"
        fi
    done
    V_TFK_IMAGES_CLEANUP="$IMAGES_CLEANUP"
}

function F_TFK_VERIFY_ACME() {
    if [[ "$V_TFK_ENV" == "web" && ! -f "${V_TFK_ROOT}/conf/acme.json" ]]; then
        F_TFK_DRAW_OUT "Creating \033[036mconf/acme.json\033[0m"
        touch "$V_TFK_ROOT/conf/acme.json"
        if [[ ! -f "$V_TFK_ROOT/conf/acme.json" ]]; then
            F_TFK_DRAW_BREAK
            F_TFK_DRAW_OUT "\033[031mError: creating ${V_TFK_ROOT}/conf/acme.json failed, aborting\033[0m"
            F_TFK_DRAW_END
            exit 1
        fi
        chmod 0600 "${V_TFK_ROOT}/conf/acme.json"
        ls -la --color "${V_TFK_ROOT}/conf"| grep --color=always "acme.json"
        F_TFK_DRAW_RULER
    fi
}

function F_TFK_VERIFY_TOMLS() {
    local V_FILE=""
    for V_FILE in "traefik_dynamic_test.toml" "traefik_dynamic_web.toml" "traefik_test.toml" "traefik_web.toml"; do
        if [[ ! -f "${V_TFK_ROOT}/conf/${V_FILE}" ]]; then
            F_TFK_DRAW_OUT "\033[033mWarning: file $V_TFK_ROOT/conf/$V_FILE not found.\033[0m"
            echo -e -n "\033[036m│\033[0m Do you want to create it now? (\033[036my\033[0m/\033[036mN\033[0m) \033[036m"
            local V_CONFIRM=""
            read V_CONFIRM
            echo -e -n "\033[0m"
            if [[ "$V_CONFIRM" != "y" && "$V_CONFIRM" != "y" ]]; then
                F_TFK_DRAW_BREAK
                F_TFK_DRAW_OUT "\033[031mAborted\033[0m"
                F_TFK_DRAW_END
                exit 1
            fi
            cp "${V_TFK_ROOT}/conf/${V_FILE}.example" "${V_TFK_ROOT}/conf/${V_FILE}"
            if [[ ! -f "${V_TFK_ROOT}/conf/${V_FILE}" ]]; then
                F_TFK_DRAW_BREAK
                F_TFK_DRAW_OUT "\033[031mError: creating ${V_TFK_ROOT}/conf/${V_FILE} failed, aborting\033[0m"
                F_TFK_DRAW_END
                exit 1
            fi
        fi
    done
}

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

function F_TFK_BOOL() {
    local V_VALUE="$1"
    if [[ "$V_VALUE" == "1" || ${V_VALUE^^} == "Y" || ${V_VALUE^^} == "YES"  || ${V_VALUE^^} == "TRUE" ]]; then
        echo -n 1
    else
        echo -n 0
    fi
}

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
