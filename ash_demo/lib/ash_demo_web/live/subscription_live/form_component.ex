defmodule AshDemoWeb.SubscriptionLive.FormComponent do
  use AshDemoWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage subscription records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="subscription-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:type]} type="text" label="Type" /><.input
          field={@form[:destination]}
          type="text"
          label="Destination"
        /><.input field={@form[:event]} type="text" label="Event" /><.input
          field={@form[:resource]}
          type="text"
          label="Resource"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Subscription</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"subscription" => subscription_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, subscription_params))}
  end

  def handle_event("save", %{"subscription" => subscription_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: subscription_params) do
      {:ok, subscription} ->
        notify_parent({:saved, subscription})

        socket =
          socket
          |> put_flash(:info, "Subscription #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{subscription: subscription}} = socket) do
    form =
      if subscription do
        AshPhoenix.Form.for_update(subscription, :update,
          as: "subscription",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(AshDemo.Notifications.Subscription, :create,
          as: "subscription",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
