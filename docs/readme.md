{%= name %} {%= badge("fury") %}
================================

> {%= description %}

**Warning:** Still in the experimental stage; may break at any moment.

{%= include("install-global") %}

General help
------------

    {%= partial("usage.md") %}

Running
-------

You can run the external grader in two configurations:

1.  As a server
2.  As a command line tool to run jailed programs

### Running as a server

Simply invoking on the command line with `serve` starts the server
listening on the specified port (default: 1666). At the moment, the
grader has an app-armor profile for the following languages:

-   Javascript (through NodeJS)
-   Octave

### Adding your own script engine

To add your own script engine, you should add an engine profile in
`profile.ls`:

#### Managing the server

To easily manage the server (optional), there are two npm scripts
(`start` and `stop`) to make you run the grader in server mode and
expose it to the internet. These scripts use `pm2` to start and stop
both the grader and an `ngrok` server. The ngrok server should be
configured with an `.ngrok` file; this is my `~/.ngrok` file:

    auth_token: your auth token
    tunnels:
        grader:
            subdomain: "grader.cms.zaccaria"
            proto:
                http: 1666

After `ngrok` started, the server is reachable in this case at:
`http://grader.cms.zaccaria.ngrok.com`. This is the address to use for
the Edx push `xqueue`.

Development
===========

Tests
-----

Tests are categorized in two parts:

1.  Integration tests for the server part (via `supertest`);
2.  Command line execution: these test the sequencing of actions that
    should be done when launching an application through a confinement
    system (if it is available for your platform).

Author
------

{%= include("author") %}

License
-------

{%= copyright() %} {%= license() %}

------------------------------------------------------------------------

{%= include("footer") %}
