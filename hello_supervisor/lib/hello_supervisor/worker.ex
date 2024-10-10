# lib/hello_supervisor/worker.ex
defmodule HelloSupervisor.Worker do
  use GenServer
  require Logger
  @offset 499

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:say_hello, state) do
    Logger.info("Hello from process #{inspect(self())}")
    schedule_work()
    {:noreply, state}
  end

  def schedule_work() do
    Process.send_after(self(), :say_hello, random_interval(5_000))
  end

  defp random_interval(max) do
    :rand.uniform(max - @offset) + @offset
  end
end
