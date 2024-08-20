defmodule DynamicInputsWeb.WebhookLive.Index do
  use DynamicInputsWeb, :live_view

  alias DynamicInputs.Engine
  alias DynamicInputs.Engine.Webhook

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :webhooks, Engine.list_webhooks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Webhook")
    |> assign(:webhook, Engine.get_webhook!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Webhook")
    |> assign(:webhook, %Webhook{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Webhooks")
    |> assign(:webhook, nil)
  end

  @impl true
  def handle_info({DynamicInputsWeb.WebhookLive.FormComponent, {:saved, webhook}}, socket) do
    {:noreply, stream_insert(socket, :webhooks, webhook)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    webhook = Engine.get_webhook!(id)
    {:ok, _} = Engine.delete_webhook(webhook)

    {:noreply, stream_delete(socket, :webhooks, webhook)}
  end
end
