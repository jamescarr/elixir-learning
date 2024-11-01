# lib/hello_supervisor/worker.ex
defmodule HelloSupervisor.Worker do
  use GenServer
  require Logger
  @offset 499
  @workers [
    :"HelloSupervisor.Worker_1",
    :"HelloSupervisor.Worker_2"
  ]

  def workers, do: @workers

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def next(%{worker: worker}) do
    case Enum.find_index(@workers, &(&1 == worker)) do
      # if we are at the end, go to the beginning
      index when index == length(@workers) -1 ->
        List.first(@workers)

      index when not is_nil(index) ->
        Enum.at(@workers, index + 1)

      nil ->
        List.first(@workers)
    end

  end

  @impl true
  def init(_) do
    run_publisher = Application.get_env(
      :genserver_demo, :publisher
    )[:run_publisher]
    current_worker = %{worker: List.first(@workers)}
    if run_publisher == "true" do
      schedule_work(current_worker)
    end

    {:ok, current_worker}
  end

  @impl true
  def handle_info({:say_hello, _msg}, state) do
    Logger.info("Hello from process #{inspect(self())} on #{Node.self()}")
    {:noreply, schedule_work(state)}
  end

  def schedule_work(state) do
    name = next(state)
    Logger.info(state)
    pid = :global.whereis_name(name)
    if is_pid(pid) do
      Process.send_after(pid, {:say_hello, :foo}, random_interval(5_000))
    else
      Logger.error("process not found")
    end

    %{state | worker: name}
  end

  defp random_interval(max) do
    :rand.uniform(max - @offset) + @offset
  end
end
