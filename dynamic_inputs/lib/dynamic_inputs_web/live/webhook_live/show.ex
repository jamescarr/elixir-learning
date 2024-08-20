defmodule DynamicInputsWeb.WebhookLive.Show do
  use DynamicInputsWeb, :live_view

  alias DynamicInputs.Engine

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:webhook, Engine.get_webhook!(id))}
  end

  defp page_title(:show), do: "Show Webhook"
  defp page_title(:edit), do: "Edit Webhook"
end
