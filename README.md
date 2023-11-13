# traefik

A ready-to-use Traefik container which makes it easier to run multiple apps at the same time
without too much configuration. This repository could also be a starting point or serve as
an example.

## Create a password

This is how to create a password for your user defined in ``conf/traefik_dynamic_web.toml``.

```sh
$ sudo apt-get install -y apache2-utils
$ htpasswd -n username
```

## Create symlinks

```sh
sudo ln -s /home/user/.docker/traefik/scripts/up.sh /usr/local/bin/traefik-up
sudo ln -s /home/user/.docker/traefik/scripts/down.sh /usr/local/bin/traefik-down
```

## Resources

- https://www.digitalocean.com/community/tutorials/how-to-use-traefik-v2-as-a-reverse-proxy-for-docker-containers-on-ubuntu-20-04
