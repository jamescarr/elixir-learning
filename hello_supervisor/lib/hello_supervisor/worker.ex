defmodule HelloSupervisor.Worker do
  use GenServer

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
    IO.puts("hello from process #{inspect(self())}")
    schedule_work()
    {:noreply, state}
  end

  def schedule_work() do
    Process.send_after(self(), :say_hello, 5_000)
  end

end
