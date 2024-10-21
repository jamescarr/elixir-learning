defmodule PentoWeb.GameLive.ControlPanel do
  use PentoWeb, :live_component
  alias Pento.Game.{Board, Pentomino}
  import PentoWeb.GameLive.{Colors, Component}


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
    <div id={ @id } phx-window-keydown="key" phx-target={ @myself }>
      <.control_panel view_box="0 0 100 100">
        <.triangle x={0} y={0} rotate={0} fill={:light_blue} />
      </.control_panel>
    </div>
    """
  end

end
