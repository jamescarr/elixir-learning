defmodule HibernatingServer do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts,
      name: __MODULE__,
      hibernate_after: 1_000,
      timeout: 1_000)
  end

  def init(_opts) do
    Process.flag(:trap_exit, true)
    {:ok, %{count: 0}, :hibernate}
  end

  def handle_call(:ping, _from, state) do
    new_count = state.count + 1
    Logger.info("Ping received. Count: #{new_count}")
    {:reply, {:ok, new_count}, %{state | count: new_count}, :hibernate}
  end

  def handle_info(:timeout, state) do
    Logger.info("Server hibernating")
    {:noreply, state, :hibernate}
  end

  def handle_info(:hibernate, state) do
    Logger.info("Hibernate message received, going into hibernation")
    {:noreply, state, :hibernate}
  end

  def handle_info({:EXIT, pid, reason}, state) do
    Logger.warning("Linked process #{inspect(pid)} exited with reason: #{inspect(reason)}")
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, pid, reason}, state) do
    Logger.warning("Monitored process #{inspect(pid)} went down with reason: #{inspect(reason)}")
    {:noreply, state}
  end

  def ping do
    GenServer.call(__MODULE__, :ping)
  end
end
