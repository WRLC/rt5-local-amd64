# rt5.local.docker

Dockerized local dev environment for [Request Tracker 5](https://bestpractical.com/request-tracker) with initialized database.

## Background

Having encountered issues with the installation of Perl libraries through Request Tracker's own `fixdeps` command in a Dockerfile, I switched to installing Ubuntu's Perl libraries via `apt install`.

The included Dockerfile should cover all of RT5's core dependencies, as well as those for EXTERNALAUTH, FASTCGI, GD, GPG, GRAPHVIZ, MYSQL, and SMIME.

No additional RT plugins are installed or enabled. No email functionality is enabled either.

The included RT_SiteConfig.pm file is configured to use a MariaDB database that is included in docker-compose.yml. The database is initialized from an included MySQL dump file that includes all default tables for a fresh install of RT5. As a result, there's no need to run `make initialize-database` or `rt-setup-database` either in the Dockerfile or after starting the container.

## Requirements

### Traefik

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

### AuthMemCookie/simpleSAMLphp/memcached

This RT5 implementation also enables the `$WebRemoteUserAuth` option, which requires an environment variable `REMOTE_USER` to be set by the web server. If a username matching `REMOTE_USER` exists, RT will log in that user, if not a new unprivileged user is created. (Fallback to RT's own login form is disabled.)

In this implementation, the `REMOTE_USER` value is set by the [AuthMemCookie Apache Module](https://zenprojects.github.io/Apache-Authmemcookie-Module/), retrieving user field values from a memcached store with a hostname of 'aladin-memcached' on port 11211. The `REMOTE_USER` value is set to the value of the 'username' field in the memcached store.

The error directive in the Apache configuration is set to `ErrorDocument 401 /login.html` which redirects to a [simpleSAMLphp](https://simplesamlphp.org/) implementation at `https:simplesamlphp.wrlc.localhost/samlphp`, specifically to an authscript named `session.php`.

The simpleSAMLphp implementation, the authorization script that stores user fields in memcached and sets the cookie read by AuthMemCookie, and memcached store are NOT included in this repository.

## Usage

1. Clone this repository: \
`git clone git@github.com:WRLC/rt5.local.docker.git`
2. Start the container: \
`docker-compose up -d`
3. Visit [https://rt5.wrlc.localhost](https://rt5.wrlc.localhost) in your browser.