# Semantic MediaWiki as a docker container

Inspired by:

 * https://github.com/wikimedia/mediawiki-docker
 * https://github.com/toniher/docker-SemanticMediaWiki

 * To build: `build.sh`

## The layers involved

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


## Why is this complicated

* *Somebody really needs to write a kube-oriented setup script*.  There is a graphical installer and a CLI installer and both of them want to generate you a config file, whereas I want a script that will safely provision a fresh database based on the values in the config file that already exists.  And then the SemanticMediaWiki portion of things is separate from the MediaWiki portion of things.
* No environment variables for configuration, no clear separation of the secret-secrets (the secret key and the database passwords, for example) from the configuration details.
* Any MediaWiki extensions you want to run (and you want to run them) frequently need system dependencies.  Because MediaWiki is *old* a lot of the popular regular extensions aren't available yet as composer dependencies, so you also need to pull in files from random repos in weird places.  Ergo, if you want to run any customized set of extensions, you will need to make your own dockerfile.  This isn't actually that bad; lots of software requires you to run customized Docker builds if you want a custom module and lots of software that's still useful bit a bit old wasn't designed for a technology and methodology that didn't exist at the time.

## Debugging tips..

Add this to the `LocalSettings.php` or `LocalSettings.local.php` to get helpful error messages:

```
$wgShowExceptionDetails = true;
$wgShowDBErrorBacktrace = true;
$wgShowSQLErrors = true;
```

## Running sqlite locally for messing around purposes

You want to do something like this:
```
docker run --name some-mediawiki --rm -p 8080:80 -v `pwd`/conf:/var/www/conf -v `pwd`/data:/var/www/data docker.pkg.github.com/wirehead/semantic-mediawiki
```

Also note that the `data` directory needs to be writable to the `www-data` user.  Not just the files.  The whole directory.

