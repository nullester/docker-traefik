#!/usr/bin/env bash

docker stop $( docker ps -a | grep "traefik" | awk '{print $1}' ) > /dev/null 2>&1

echo
docker ps -a

echo
docker system prune -f

docker rmi $( docker image ls | grep "traefik" | awk '{print $3}' ) > /dev/null 2>&1

exit 0
