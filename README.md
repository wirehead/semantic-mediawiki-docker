# Semantic MediaWiki as a docker container

![Docker Image CI](https://github.com/wirehead/semantic-mediawiki-docker/workflows/Docker%20Image%20CI/badge.svg)

![Logo](https://raw.githubusercontent.com/wirehead/semantic-mediawiki-docker/master/icons/favicon-202x202.png)

A nice Docker container designed for running [Semantic MediaWiki](https://www.semantic-mediawiki.org/) with a set of useful modules already installed in a kubernetes-styled situation.

You probably don't want to run the containers as-is, it's mostly intended for use with my matching [helm chart](https://github.com/wirehead/wirehead-charts/tree/master/charts/semanticmediawiki)

**WORK IN PROGRESS WARNING**: I'm totally not finished messing with this.

## Basic operation

This is primarily designed to run atop Kube, but here's some entrypoints if you want to play with things:

 * To build the container: `build.sh`
 * To run a browser container: `run.sh`
 * To run a cron container: `cron.sh`
 * To run a worker node container: `jobs.sh`

### Quickstart

## Environment variables

| Environment Variable       | Config Var       | Default Value            | Description  |
| -------------------------- | ---------------- | ------------------------ | ------------------- |
| MEDIAWIKI_DEBUG            |                  | unset                    | Set this to enable debug traces |
| MEDIAWIKI_DISABLE_ICONS    | $wgFooterIcons   | unset                    | Set this to disable footer icons |
| MEDIAWIKI_SITE_SERVER      | $wgServer        | `http://127.0.0.1:8080` | Set this to the server host, protocol, and port if it's not a standard port. This is what MediaWiki uses to generate URLs |
| MEDIAWIKI_SCRIPT_PATH      | $wgScriptPath    | null | The base URL path |
| MEDIAWIKI_UPLOAD_PATH      | $wgUploadPath    | null | The path for uploads |
| MEDIAWIKI_SITE_NAME        | $wgSitename      | `tst`                      | Name of the site |
| MEDIAWIKI_SITE_LANG        | $wgLanguageCode  | `en`                       | Language of the site|
| MEDIAWIKI_ADMIN_USER       |                  | `admin`                    | Name of the admin user |
| MEDIAWIKI_ADMIN_PASS       |                  | `password`                 | Default password for the admin user |
| MEDIAWIKI_DB_TYPE          | $wgDBtype        | `sqlite`                   | DB style (sqlite, postgres, or mysql) |
| MEDIAWIKI_DB_HOST          | $wgDBserver      |                          | hostname for the DB (unneccessary for sqlite) |
| MEDIAWIKI_DB_USER          | $wgDBuser        |                          | database user (not to be confused with admin user; this is how you log into the database) |
| MEDIAWIKI_DB_PASSWORD      | $wgDBpassword    |                          | database password (not to be confused with admin password; this is how you log into the database) |
| MEDIAWIKI_DB_NAME          | $wgDBname        |` my_wiki`                  | database name |
| MEDIAWIKI_DB_PORT          | $wgDBport        |                          | database port |
| MEDIAWIKI_DB_SCHEMA        | $wgDBmwschema    |                          | database schema (for postgresql) |
| MEDIAWIKI_DATABASE_DIR     | $wgSQLiteDataDir | `/var/www/data`            | database directory (for sqlite) |
| MEDIAWIKI_SECRET_KEY       | $wgSecretKey     | ......                   | secret key |
| MEDIAWIKI_ENABLE_UPLOADS   | $wgEnableUploads | unset                    | set a value to enable uploads |
| MEDIAWIKI_ENABLE_EMAIL     | $wgEnableEmail   | unset                    | set a value to enable email |
| MEDIAWIKI_EMAIL_PW_SENDER  | $wgEmergencyContact | `nobody@example.com` | Password sender email |
| MEDIAWIKI_EMAIL_EMERG_CONT | $wgPasswordSender | `nobody@example.com`      | Emergency contact |
| SMW_SEMANTIC_URL           |                  | `http://www.example.com/`  | SemanticMediaWiki namespace for RDF properties |

## Some details

### A brief and non-normative list of what you want to do to run things in a kubernetes-styled situation

 1. One process strictly for each container.  This is why pods schedule multiple containers per pod.  No supervisord or other such process supervision; your container runtime handles this.
 2. Secrets maintained separately from configuration, so you can inject them as a Secret.
 3. Config files exist in a directory that you can use a ConfigMap to inject them.
 4. Stateless containers, which precludes a *lot* of ways to do a 'friendly' setup.
 5. Database is a separate concern.  Users may want to use a hosted database (Amazon RDS or the like) or at least store multiple different instances in a single bigger database.  Helm charts that include their own database are not great here.
 6. If you are going to have local files, they need to be easily mapped and mounted volumes.
 7. Contains a discrete setup process that won't accidentally wipe out your stuff.

### The layers involved

1. Debian Buster
2. [PHP 7.2 Buster Apache](https://hub.docker.com/_/php/)
3. [MediaWiki](https://github.com/wikimedia/mediawiki-docker)
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

## Persistent Data

### Database

Also note that the `data` directory needs to be writable to the `www-data` user.  Not just the files.  The whole directory.

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

## Inspired by:

 * https://github.com/wikimedia/mediawiki-docker
 * https://github.com/toniher/docker-SemanticMediaWiki
 * https://github.com/benhutchins/docker-mediawiki
