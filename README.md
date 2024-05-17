# rt5.local.docker

Dockerized local dev environment for Request Tracker 5 with initialized database.

## Background

Having encountered issues with the installation of Perl libraries through 
Request Tracker's own `fixdeps` command in a Dockerfile, I switched to 
installing Ubuntu's Perl libraries `apt install`.

The included Dockerfile should cover all of RT5's core dependencies, as well 
as those for EXTERNALAUTH, FASTCGI, GD, GPG, GRAPHVIZ, MYSQL, and SMIME. No
additional RT plugins are installed or enabled. No email functionality is
enabled either.

The included RT_SiteConfig.pm file is configured to use a MariaDB database
that is included in docker-compose.yml. The database is initialized from an
included MySQL dump file that includes all default tables for a fresh install
of RT5. As a result, there's no need to run `make initialize-database` or
`rt-setup-database` either in the Dockerfile or after starting the container.

## Requirements
This implementation depends on Traefik using a docker-compose file that includes the following:
```yaml
services:
  traefik:
    image: traefik:v2.10
    command:
      - "--log.level=DEBUG"
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      - "--entrypoints.web.http.redirections.entryPoint.scheme=https"
      - "--entrypoints.websecure.address=:443"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - proxy


networks:
  proxy:
    external: true
```
The traefik service can be added to the docker-compose.yml file for this project, or it can run in a separate external container. 

The important thing is that the traefik service is running and the network `proxy` is available to the rt5 service.

This RT5 implementation also enables the `$WebRemoteUserAuth` option, which requires an environment variable `REMOTE_USER` to be set by the web server. If 
a username matching `REMOTE_USER` exists, RT will log in that user, if not a new unprivileged user is created. (Fallback to RT's own login form is disabled.)

## Usage

1. Clone this repository: \
`git clone git@github.com:WRLC/rt5.local.docker.git`
2. Start the container: \
`docker-compose up -d`
3. Access RT5 in your browser (https://rt5.wrlc.localhost): \
Username: `root` \
Password: `password`