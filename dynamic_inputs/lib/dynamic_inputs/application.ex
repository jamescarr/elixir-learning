defmodule DynamicInputs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DynamicInputsWeb.Telemetry,
      DynamicInputs.Repo,
      {DNSCluster, query: Application.get_env(:dynamic_inputs, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DynamicInputs.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DynamicInputs.Finch},
      # Start a worker by calling: DynamicInputs.Worker.start_link(arg)
      # {DynamicInputs.Worker, arg},
      # Start to serve requests, typically the last entry
      DynamicInputsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DynamicInputs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DynamicInputsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
