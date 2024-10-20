defmodule HelloSupervisor.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_supervisor,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :wx, :observer],
      mod: {HelloSupervisor, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:amqp, "~> 3.3"},
      {:jason, "~> 1.4"}
    ]
  end
end
