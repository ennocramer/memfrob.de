# memfrob.de

The website for memfrob.de, built with
[Gutenberg](https://getgutenberg.io), [Picnic
CSS](https://picnicss.com), and [Fontello](http://fontello.com).


## Building

Use the `Makefile` or the `gutenberg` binary directly.

Run `make serve` or `gutenberg serve` to run a local webserver.

Run `make build-staging` to build the site for `design.memfrob.de`.

Run `make build-production` to build the site for `memfrob.de`.

Run `gutenberg build -u <URL>` to build the site for any other domain.


## Deploying

The site is deployed using `rsync`.  Make sure to have the proper SSH
key loaded via `ssh-add`.

Run `make deploy-staging` to build and deploy to `design.memfrob.de`.

Run `make deploy-production` to build and deploy to `memfrob.de`.


## Updating Dependencies

Run `make update-picnic` to pull the most recent version of Picnic CSS
from the git repository.

Run `make update-fontello` to retrieve a new font package and matching
CSS files from fontello.  Edit `fontello.conf` beforehand to add icons.
