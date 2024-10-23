import Config
config :ash_demo, token_signing_secret: "dXLI1uvy1Bei/grI/tGdgZj02xVWv4Zp"
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ash_demo, AshDemo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ash_demo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ash_demo, AshDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zuMfmqdN7V9gxu1C47zQvnBCl0GSW2nONXAKs/JoZfz6iZPB/K5j3hg4bYb+vbQz",
  server: false

# In test we don't send emails
config :ash_demo, AshDemo.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
