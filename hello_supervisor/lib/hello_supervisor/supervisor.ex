# lib/hello_supervisor/supervisor.ex
defmodule HelloSupervisor.Supervisor do
  use Supervisor
  require UUID

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = Enum.map(1..5, fn _ ->
      %{
        id: UUID.uuid4(:default),
        start: {HelloSupervisor.Worker, :start_link, [[]]},
        restart: :permanent
      }
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
