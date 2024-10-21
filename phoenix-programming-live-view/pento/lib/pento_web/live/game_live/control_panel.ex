defmodule PentoWeb.GameLive.ControlPanel do
  use PentoWeb, :live_component
  alias Pento.Game.{Board, Pentomino}
  import PentoWeb.GameLive.{Colors, Component}
  require Logger

  def update(%{id: id}, socket) do
    {:ok,
      socket
      |> assign_params(id)
    }
  end

  defp assign_params(socket, id) do
    assign(socket, id: id)
  end


  def render(assigns) do
    ~H"""
    <div id={ @id } phx-window-keydown="key" phx-target={ @myself } style="border: 1px dashed #000;">
      <.control_panel view_box="0 0 200 40">
        <.triangle x={24} y={0} rotate={0} fill={:light_blue} />
        <.triangle x={14} y={50} rotate={90} fill={:dark_green} />
        <.triangle x={62} y={60} rotate={180} fill={:blue} />
        <.triangle x={74} y={12} rotate={270} fill={:light_green} />
      </.control_panel>
    </div>
    """
  end

  def handle_event(name, payload, socket) do
    Logger.info("Event caught but unhandled, #{name}")
    Logger.info("Payload: #{inspect(payload)}")
    {:noreply, socket}
  end

end
