# Quick Reference

- Maintained By: [Yersa Nordman](https://github.com/finwo/docker-adminer)
- Where to file issues: https://github.com/finwo/docker-adminer/issues

# Adminer

## What is adminer?

Adminer (formerly phpMinAdmin) is a full-featured database management tool
written in PHP. Conversely to phpMyAdmin, it consist of a single file ready to
deploy to the target server. Adminer is available for MySQL, PostgreSQL, SQLite,
MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.

## How to use this image

### Standalone

```
$ docker run -p 8080:8080 finwo/adminer
```

Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your
browser.

### Loading plugins

This image bundles all official Adminer plugins. You can find the list of
plugins on GitHub: https://github.com/vrana/adminer/tree/master/plugins. By
default, the `login-password-less` plugin is enabled when entering `nopassword`
in the password field during connecting.

To load plugins you can pass a list of filenames in ADMINER_PLUGINS:

```
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='tables-filter tinymce' finwo/adminer
```

If a plugin *requires* parameters to work correctly you will need to add a
custom file to the container:

```
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='login-servers' finwo/adminer
Unable to load plugin file "login-servers", because it has required parameters: servers
Create a file "/var/www/html/plugins-enabled/login-servers.php" with the following contents to load the plugin:

<?php
require_once('plugins/login-servers.php');

/** Set supported servers
    * @param array array($domain) or array($domain => $description) or array($category => array())
    * @param string
    */
return new AdminerLoginServers(
    $servers = ???,
    $driver = 'server'
);
```

To load a custom plugin you can add PHP scripts that return the instance of the
plugin object to `/var/www/html/plugins-enabled/`.

### Choosing a design

The image bundles all the designs that are available in the source package of
adminer. You can find the list of designs on GitHub:
https://github.com/vrana/adminer/tree/master/designs.

To use a bundled design you can pass its name in `ADMINER_DESIGN`:

```
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_DESIGN='nette' finwo/adminer
```

To use a custom design you can add a file called `/var/www/html/adminer.css`.

### Usage with external server

You can specify the default host with the `ADMINER_DEFAULT_SERVER` environment
variable. This is useful if you are connecting to an external server or a docker
container named something other than the default `db`.

```
docker run -p 8080:8080 -e ADMINER_DEFAULT_SERVER=mysql finwo/adminer
```

## Supported drivers

While Adminer supports a wide range of database drivers this image only supports
the following out of the box:

- MySQL
- PostgreSQL
- SQLite
- SimpleDB
- Elasticsearch
- MongoDB
- Oracle

To add support for the other drivers you will need to install the following PHP
extensions on top of this image:

- `pdo_dblib` (MS SQL)
- `interbase` (Firebird)

# License

View [license information](https://github.com/vrana/adminer/blob/master/readme.txt)
for the software contained in this image.

As with all Docker images, these likely also contain other software which may be
under other licenses (such as Bash, etc from the base distribution, along with
any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to
ensure that any use of this image complies with any relevant licenses for all
software contained within.
