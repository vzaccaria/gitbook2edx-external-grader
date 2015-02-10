# {%= name %} {%= badge("fury") %}

> {%= description %}

**Warning:** Still in the experimental stage; may break at any moment.

{%= include("install-global") %}

## General help 

```
{%= partial("usage.md") %}
```

## Running

The makefile has two targets (`start` and `stop`) to make you run the grader in server mode and expose it to the internet. These targets use `pm2` to start and stop both the grader and an `ngrok` server. The ngrok server should be configured with an `.ngrok` file; this is my `~/.ngrok` file:

```
auth_token: your auth token
tunnels:
    grader:
        subdomain: "grader.cms.zaccaria"
        proto:
            http: 1666
```

After `ngrok` started, the server is reachable in this case at: `http://grader.cms.zaccaria.ngrok.com`. This is the address to use for the Edx push `xqueue`.

## Tests

Tests are categorized in three parts:

1. Tests for the server part (via `supertest`); these dont really require app-armor. They just check that data the overall client-server protocol complies with `xqueue` specs (invoked with `make test`).
2. Fake tests for the code-jail environment; these test the sequencing of actions that should be done when launching an application through app-armor, even if you dont have app-armor (e.g., I am developing on a Mac). These are invoked by `./test/test.sh`.
3. App-armor execution; these run some sample scripts under app-armor, by assuming you are under linux 14.04. These are invoked by `./test-local/test.sh`

## Author
{%= include("author") %}

## License
{%= copyright() %}
{%= license() %}

***

{%= include("footer") %}
