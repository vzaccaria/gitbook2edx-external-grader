# {%= name %} {%= badge("fury") %}

> {%= description %}

{%= include("install-global") %}

## General help 

```
{%= partial("usage.md") %}
```

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
