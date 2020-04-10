# MYPI

This repo contains all the scripts which I install on my raspberry pi (=MYPI).
As a raspberry pi has so limited resources, I decided to use Alpine Linux in a
very limited configuration as base system.

The following packages have been installed:

- bash
- docker
- git
- jq
- sudo
- wireless-tools
- wpa_supplicant

All services provided by MYPI are docker based.

## Manual installation

After Alpine Linux has been installed, you have to clone this repo to
`/opt/mypi`:

```bash
mkdir -p /opt/
cd /opt
git clone https://github.com/dueckminor/mypi.git
```

## The CLI

To use the CLI execute the following from a `bash`:

```bash
eval "$(/opt/mypi/bin/mypi bash_enable)"
```

## Building docker images

```bash
mypi docker nsd build
mypi docker nginx build
mypi docker certbot build
```
