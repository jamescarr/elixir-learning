defmodule HelloSupervisor.Publisher do
  use GenServer

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def publish(server, message) when is_map(message) do
    GenServer.call(server, {:publish, message})
  end

  # Server Callbacks

  @impl true
  def init(:ok) do
    name = String.to_atom("publisher_#{inspect(self())}")
    Process.register(self(), name)
    case setup_rabbitmq() do
      {:ok, conn, chan} ->
        {:ok, %{conn: conn, chan: chan}}
      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_call({:publish, message}, _from, state) do
    message_with_pid = Map.put(message, :process_id, inspect(self()))
    json_message = Jason.encode!(message_with_pid)

    result = AMQP.Basic.publish(
      state.chan,
      "test_exchange",
      "",
      json_message
    )

    {:reply, result, state}
  end

  @impl true
  def terminate(_reason, state) do
    AMQP.Connection.close(state.conn)
  end

  # Private Functions

  defp setup_rabbitmq do
    with {:ok, conn} <- AMQP.Connection.open(),
         {:ok, chan} <- AMQP.Channel.open(conn) do
      AMQP.Queue.declare(chan, "test_queue")
      AMQP.Exchange.declare(chan, "test_exchange")
      AMQP.Queue.bind(chan, "test_queue", "test_exchange")
      {:ok, conn, chan}
    end
  end
end
