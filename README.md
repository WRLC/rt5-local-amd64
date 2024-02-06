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

The only manual tasks required are to create a self-signed SSL certificate and
to edit your /etc/hosts file.

## Usage

1. Clone this repository: \
`git clone git@github.com:WRLC/rt5.local.docker.git`
2. Change to the repository directory: \
`cd rt5.local.docker`
3. Create a folder called ssl: \
`mkdir ssl`
4. Create a self-signed SSL certificate in the ssl folder:\
`openssl req -x509 -newkey rsa:4096 -keyout ssl/mycert.key -out ssl/mycert.crt -days 365 -nodes`
5. Edit /etc/hosts file to include the following line: \
`127.0.0.1 rt5.local.docker`
6. Start the container: \
`docker-compose up -d`
7. Access RT5 in your browser (https://rt5.local.docker): \
Username: `root` \
Password: `password`