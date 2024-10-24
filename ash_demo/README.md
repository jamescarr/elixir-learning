# AshDemo
Demo project using ash to manage something (blog posts) and a subscription
based "resthooks" api to send notifications of changes.

## MVP

- [x] Blog domain with Post resource
  - [x] web frontend
  - [x] rest api
- [ ] Notifications domain with Subscription resource
 - [ ] Subscription
   - [ ] type: webhook
   - [ ] url: destination_url
   - [ ] event: create | update | delete
   - [ ] resource: "domain.resource" (e.g. "blog.post")

### Notications

    mix ash.gen.domain AshDemo.Notifications
    mix ash.gen.resource AshDemo.Notifications.Subscription \
      --default-actions read,create,update,destroy \
      --uuid-primary-key id \
      --attribute type:string:required:public \
      --attribute destination:string:required:public \
      --attribute event:string:required:public \
      --attribute resource:string:required:public \
      --relationship belongs_to:user:AshDemo.Accounts.User \
      --timestamps \
      --extend postgres,json_api

## Development

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
