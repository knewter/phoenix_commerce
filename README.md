# PhoenixCommerce

This is a Phoenix-based e-commerce application being built as a series for
[ElixirSips](http://www.elixirsips.com).

## Development

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests

The tests are heavily focused on acceptance-tests that drive a browser.
Consequently, you need to run a webdriver for them to connect to.  At present
they expect phantomjs, so run it in another terminal session with:

```sh
phantomjs --wd
```

Then you can run the tests with:

```sh
mix test
```

## Production

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
