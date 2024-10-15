# lib/hello_supervisor/worker.ex
defmodule HelloSupervisor.Worker do
  use GenServer
  require Logger
  alias HelloSupervisor.Publisher
  @min_interval 500
  @max_interval 5_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, publisher} = HelloSupervisor.Publisher.start_link()

    schedule_work()
    {:ok, %{publisher: publisher}}
  end

  @impl true
  def handle_info(:say_hello, state) do
    Logger.info("Hello from process #{inspect(self())}")
    message = %{id: UUID.uuid4(), worker_id: inspect(self())}
    Publisher.publish(state.publisher, message)
    schedule_work()
    {:noreply, state}
  end

  def schedule_work() do
    Process.send_after(self(), :say_hello, random_interval(@max_interval))
  end

  defp random_interval(max) do
    :rand.uniform(max - @min_interval) + @min_interval
  end
end

