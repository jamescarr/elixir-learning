defmodule Pento.Logger do
  require Logger

  def attach do
    :telemetry.attach(
      "finch-request-logger",
      [:finch, :request, :stop],
      &__MODULE__.handle_event/4,
      nil
    )
  end

  def handle_event(_event_name, measurements, metadata, _config) do
    {_, response} = metadata.result
    details = %{
      response_status: response.status,
      request_host: metadata.request.host,
      request_method: metadata.request.method,
      request_path: metadata.request.path,
      duration: measurements.duration
    }
    if response.status > 400 do
      Logger.error("#{inspect(details)}")
    else
      Logger.info("#{inspect(details)}")
    end

  end
end
