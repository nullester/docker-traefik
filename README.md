# traefik

To use Traefik locally or on Digital Ocean

## Create a password

This is how to create a password for your user defined in ``conf/traefik_dynamic_web.toml``.

```sh
$ sudo apt-get install -y apache2-utils vim
$ htpasswd -nb username password
```

## Resources

- https://www.digitalocean.com/community/tutorials/how-to-use-traefik-v2-as-a-reverse-proxy-for-docker-containers-on-ubuntu-20-04
