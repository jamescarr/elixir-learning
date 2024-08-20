defmodule DynamicInputsWeb.WebhookLive.FormComponent do
  use DynamicInputsWeb, :live_component

  alias DynamicInputs.Engine

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage webhook records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="webhook-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:content_type]} type="text" label="Content type" />
        <.input field={@form[:payload]} type="text" label="Payload" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Webhook</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{webhook: webhook} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Engine.change_webhook(webhook))
     end)}
  end

  @impl true
  def handle_event("validate", %{"webhook" => webhook_params}, socket) do
    changeset = Engine.change_webhook(socket.assigns.webhook, webhook_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"webhook" => webhook_params}, socket) do
    save_webhook(socket, socket.assigns.action, webhook_params)
  end

  defp save_webhook(socket, :edit, webhook_params) do
    case Engine.update_webhook(socket.assigns.webhook, webhook_params) do
      {:ok, webhook} ->
        notify_parent({:saved, webhook})

        {:noreply,
         socket
         |> put_flash(:info, "Webhook updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_webhook(socket, :new, webhook_params) do
    case Engine.create_webhook(webhook_params) do
      {:ok, webhook} ->
        notify_parent({:saved, webhook})

        {:noreply,
         socket
         |> put_flash(:info, "Webhook created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
