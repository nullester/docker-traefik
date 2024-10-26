#!/usr/bin/env bash

V_ROOT=$( realpath $( dirname $( readlink -f "$0") )/.. )

V_ISSUED_BY_NAME=$( hostname | tr '[:lower:]' '[:upper:]' )" CA"
echo -e "Using issued by name \033[036m${V_ISSUED_BY_NAME}\033[0m"

V_CERTS_PATH="${V_ROOT}/certs"
if [[ ! -d "$V_CERTS_PATH" ]]; then
    mkdir -p "$V_CERTS_PATH"
    if [[ ! -d "$V_CERTS_PATH" ]]; then
        echo -e "\033[031mError: creating certifications path ${V_CERTS_PATH}failed\033[0m"
        exit 1
    else
        echo -e "Certifications path \033[036m${V_CERTS_PATH} created\033[0m"
    fi
fi
echo -e "Using certifications path \033[036m${V_CERTS_PATH}\033[0m"

V_LOCALCA_BASENAME=$( hostname | tr '[:upper:]' '[:lower:]'  )"CA"
V_LOCALCA_KEY_FILEPATH="${V_CERTS_PATH}/${V_LOCALCA_BASENAME}.key"
echo -e "Using localCA key filepath \033[036m${V_LOCALCA_KEY_FILEPATH}\033[0m"
V_LOCALCA_PEM_FILEPATH="${V_CERTS_PATH}/${V_LOCALCA_BASENAME}.pem"
echo -e "Using localCA pem filepath \033[036m${V_LOCALCA_PEM_FILEPATH}\033[0m"
V_LOCALCA_SRL_FILEPATH="${V_CERTS_PATH}/${V_LOCALCA_BASENAME}.srl"
echo -e "Using localCA srl filepath \033[036m${V_LOCALCA_SRL_FILEPATH}\033[0m"
echo

if [[ ! -f "$V_LOCALCA_KEY_FILEPATH" || ! -f "$V_LOCALCA_PEM_FILEPATH" ]]; then
    openssl genrsa -out $V_LOCALCA_KEY_FILEPATH 2048
    openssl req -x509 -new -nodes -key "$V_LOCALCA_KEY_FILEPATH" -sha256 -days 1024 -out "$V_LOCALCA_PEM_FILEPATH" -subj "/CN=${V_ISSUED_BY_NAME}"
    if [[ ! -f "$V_LOCALCA_KEY_FILEPATH" || ! -f "${V_LOCALCA_PEM_FILEPATH}" ]]; then
        echo -e "\033[031mError: $( basename ${V_LOCALCA_KEY_FILEPATH} ) or $( basename ${V_LOCALCA_PEM_FILEPATH} ) file not found\033[0m"
        exit 1
    fi
fi
V_MD5_1=$( openssl x509 -noout -modulus -in "$V_LOCALCA_PEM_FILEPATH" | openssl md5 )
V_MD5_2=$( openssl rsa -noout -modulus -in "$V_LOCALCA_KEY_FILEPATH" | openssl md5 )
if [[ "$V_MD5_1" != "$V_MD5_1" ]]; then
    echo -e "\033[031mError: $( basename ${V_LOCALCA_PEM_FILEPATH} ) verification failed\033[0m"
    exit 1
fi
echo -e "\033[032m${V_LOCALCA_PEM_FILEPATH}: OK\033[0m"

echo
V_DOMAINS=()
while IFS='=' read -r V_KEY V_VALUE; do
    if [[ $V_KEY =~ ^DOMAIN_[0-9]+$ ]]; then
        V_DOMAINS+=( $( echo "$V_VALUE" | tr -d '"') )
    fi
done < ../.env
V_NUM_DOMAINS=${#V_DOMAINS[@]}
if [[ $V_NUM_DOMAINS -eq 0 ]]; then
    echo -e "\033[031mError: no certification domains found in .env file\033[0m"
    exit 1
fi
echo -e "\033[036m${V_NUM_DOMAINS}\033[0m certification domain(s) found in .env file"
echo

for V_DOMAIN in ${V_DOMAINS[@]}; do
    echo
    echo -e "Domain: \033[036m${V_DOMAIN}\033[0m"
    V_DOMAIN_KEY_FILEPATH="${V_CERTS_PATH}/${V_DOMAIN}.key"
    V_DOMAIN_CSR_FILEPATH="${V_CERTS_PATH}/${V_DOMAIN}.csr"
    V_DOMAIN_CRT_FILEPATH="${V_CERTS_PATH}/${V_DOMAIN}.crt"
    if [[ -f "$V_DOMAIN_KEY_FILEPATH" && -f "$V_DOMAIN_CSR_FILEPATH" && -f "$V_DOMAIN_CRT_FILEPATH" ]]; then
        echo "Certificates already exist, skipping creation"
        continue
    fi
    openssl genrsa -out "$V_DOMAIN_KEY_FILEPATH" 2048
    openssl req -new -sha256 -key "$V_DOMAIN_KEY_FILEPATH" -out "$V_DOMAIN_CSR_FILEPATH" \
        -subj "/CN=${V_DOMAIN}" \
        -addext "subjectAltName=DNS:${V_DOMAIN}"
    openssl x509 -req -in "$V_DOMAIN_CSR_FILEPATH" \
        -CA "$V_LOCALCA_PEM_FILEPATH" \
        -CAkey "$V_LOCALCA_KEY_FILEPATH" \
        -CAcreateserial \
        -extfile <(printf "subjectAltName=DNS:${V_DOMAIN}") \
        -out "$V_DOMAIN_CRT_FILEPATH" -days 365 -sha256
    V_VERIFY=$( openssl verify -CAfile "$V_LOCALCA_PEM_FILEPATH" "$V_DOMAIN_CRT_FILEPATH" )
    if [[ "$V_VERIFY" =~ OK$ ]]; then
        echo -e "\033[032m${V_VERIFY}\033[0m"
    else
        echo -e "\033[031m${V_VERIFY}\033[0m"
    fi
done

exit 0