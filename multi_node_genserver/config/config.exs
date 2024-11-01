import Config

config :genserver_demo, :publisher,
  run_publisher: System.get_env("RUN_PUBLISHER", "false")
