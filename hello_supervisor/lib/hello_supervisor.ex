
# lib/hello_supervisor.ex
defmodule HelloSupervisor do
  use Application

  @impl true
  def start(_type, _args) do
    HelloSupervisor.Supervisor.start_link([])
  end
end
