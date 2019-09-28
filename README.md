# Semantic MediaWiki as a docker container

A nice Docker container designed for running Semantic MediaWiki with some useful modules already installed in a kubernetes-styled situation.

## Basic operation

This is primarily designed to run atop Kube, but here's some entrypoints if you want to play with things:

 * To build the container: `build.sh`
 * To run a browser container: `run.sh`
 * To run a cron container: `cron.sh`

### Quickstart

## Some details

### A brief and non-normative list of what you want to do to run things in a kubernetes-styled situation

 1. One process strictly for each container.  This is why pods schedule multiple containers per pod.  No supervisord or other such stuff
 2. Secrets maintained separately from configuration, so you can inject them as a Secret,
 3. Config files exist in a directory that you can use a ConfigMap to inject them.
 4. Stateless containers, which precludes a *lot* of ways to do a 'friendly' setup.
 5. Database is a separate concern.  Users may want to use a hosted database (Amazon RDS or the like) or at least store multiple different instances in a single bigger database.

### The layers involved

1. Debian Buster
2. PHP 7.2 Buster Apache
3. MediaWiki LTS
4. This dockerfile that adds customizations:
    * Installs Composer
    * Installs some system-level packages
    * Installs some source blob modules
    * Uses composer to install some modules
    * Sets up a parallel directory with symlinks for the config files so you can map them
    * Drops some config files in place.

### Why is this complicated

* *Somebody really needs to write a kube-oriented setup script*.  There is a graphical installer and a CLI installer and both of them want to generate you a config file, whereas I want a script that will safely provision a fresh database based on the values in the config file that already exists.  And then the SemanticMediaWiki portion of things is separate from the MediaWiki portion of things.  I wrapped it up in `db-setup.sh` but you can see how it's kinda weird and not perfect.
* The [SemanticMediaWiki config dir](https://www.semantic-mediawiki.org/wiki/Help:Setup_information_file).  Because SemanticMediaWiki has a bunch of very specific implementation details related to not necessarily using the same SQL database as everything else and using a SPARQL store, I can see why they decided it was simpler to use a JSON file in a known place to keep track of that.
* No environment variables for configuration, no clear separation of the secret-secrets (the secret key and the database passwords, for example) from the configuration details.
* Any MediaWiki extensions you want to run (and you want to run them) frequently need system dependencies.  Because MediaWiki is *old* a lot of the popular regular extensions aren't available yet as composer dependencies, so you also need to pull in files from random repos in weird places.  Ergo, if you want to run any customized set of extensions, you will need to make your own dockerfile.  This isn't actually that bad; lots of software requires you to run customized Docker builds if you want a custom module and lots of software that's still useful bit a bit old wasn't designed for a technology and methodology that didn't exist at the time.

## Todo

 * Allow database and stuff to be configured via environment variables.
 * Cron config
 * Docs
 * Matching Helm chart

## Persistent Data

### Database

### Images

### SemanticMediaWiki config

## Debugging tips..

### Helpful error messages

Add this to the `LocalSettings.php` or `LocalSettings.local.php` to get helpful error messages:

```
$wgShowExceptionDetails = true;
$wgShowDBErrorBacktrace = true;
$wgShowSQLErrors = true;
```

### Getting at a shell

Use this to get into a shell:

```
docker exec -it some-mediawiki /bin/bash -il
```

### Running sqlite locally for messing around purposes

You want to do something like this:
```
docker run --name some-mediawiki --rm -p 8080:80 -v `pwd`/conf:/var/www/conf -v `pwd`/data:/var/www/data docker.pkg.github.com/wirehead/semantic-mediawiki
```

Also note that the `data` directory needs to be writable to the `www-data` user.  Not just the files.  The whole directory.

## Inspired by:

 * https://github.com/wikimedia/mediawiki-docker
 * https://github.com/toniher/docker-SemanticMediaWiki
