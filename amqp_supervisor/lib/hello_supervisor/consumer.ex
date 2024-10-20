# lib/hello_supervisor/consumer.ex

defmodule HelloSupervisor.Consumer do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    name = String.to_atom("consumer_#{inspect(self())}")
    Process.register(self(), name)

    send(self(), :connect)
    {:ok, %{conn: nil, chan: nil}}
  end

  @impl true
  def handle_info(:connect, _state) do
    case connect() do
      {:ok, conn, chan} ->
        Process.monitor(conn.pid)
        {:noreply, %{conn: conn, chan: chan}}
      {:error, _} ->
        Logger.error("Failed to connect to RabbitMQ. Retrying in 5 seconds...")
        Process.send_after(self(), :connect, 5000)
        {:noreply, %{conn: nil, chan: nil}}
    end
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  @impl true
  def handle_info({:DOWN, _, :process, _pid, reason}, _) do
    Logger.error("RabbitMQ connection lost: #{inspect(reason)}. Reconnecting...")
    send(self(), :connect)
    {:noreply, %{conn: nil, chan: nil}}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: _tag, redelivered: _redelivered}}, chan) do
    # You might want to run payload consumption in separate Tasks in production
    Logger.info("Received message: #{payload}")
    {:noreply, chan}
  end

  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  defp connect do
    case AMQP.Connection.open() do
      {:ok, conn} ->
        case AMQP.Channel.open(conn) do
          {:ok, chan} ->
            AMQP.Queue.declare(chan, "test_queue")
            AMQP.Basic.consume(chan, "test_queue", nil, no_ack: true)
            {:ok, conn, chan}
          {:error, _} = error -> error
        end
      {:error, _} = error -> error
    end
  end

  @impl true
  def terminate(_reason, %{conn: conn}) do
    if conn, do: AMQP.Connection.close(conn)
  end
end
