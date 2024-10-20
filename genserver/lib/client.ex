defmodule Client do
  use GenServer
  require Logger

  @interval 15_000 # 15 seconds

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    schedule_ping()
    {:ok, %{}}
  end

  def handle_info(:ping_server, state) do
    Logger.info("Client pinging server")
    {:ok, count} = HibernatingServer.ping()
    Logger.info("Server responded with count: #{count}")
    schedule_ping()
    {:noreply, state}
  end

  defp schedule_ping do
    Process.send_after(self(), :ping_server, @interval)
  end
end
