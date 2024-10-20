defmodule GenserverApp do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      HibernatingServer,
      Client
    ]

    opts = [strategy: :one_for_one, name: GenserverApp.Supervisor]

    Logger.info("Starting with children #{inspect(children)}")
    Supervisor.start_link(children, opts)

  end
end
