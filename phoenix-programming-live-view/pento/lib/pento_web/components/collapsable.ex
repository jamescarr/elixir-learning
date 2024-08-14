defmodule PentoWeb.Collapsable do
  use PentoWeb, :live_component
  import Phoenix.HTML
  alias Phoenix.LiveView.JS

  attr :expanded, :boolean, default: false
  attr :title, :string, required: true
  slot :inner_block, required: true

  def render(assigns) do
    ~H"""
    <div id={@id} phx-click={toggle(@id)} phx-target={@myself}>
      <h2 class="font-medium text-2xl flex items-center cursor-pointer">
        <span class={["carrot", "ml-2", "transform", "transition-transform",
                      "duration-200", if(!@expanded, do: "rotate-180", else: "")]}>
          <%= raw "&#9660;" %>
        </span>
        <%= @title %>
      </h2>
      <div class={["content", if(@expanded, do: "block", else: "hidden")]}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def toggle(js \\ %JS{}, id) do
    js
    |> JS.toggle_class("hidden", to: "##{id} .content")
    |> JS.toggle_class("rotate-180", to: "##{id} .carrot")
  end

  def handle_event("toggle", _, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns[:expanded])}
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end

end
