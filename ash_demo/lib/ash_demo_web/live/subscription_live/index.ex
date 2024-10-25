defmodule AshDemoWeb.SubscriptionLive.Index do
  use AshDemoWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Subscriptions
      <:actions>
        <.link patch={~p"/subscriptions/new"}>
          <.button>New Subscription</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="subscriptions"
      rows={@streams.subscriptions}
      row_click={fn {_id, subscription} -> JS.navigate(~p"/subscriptions/#{subscription}") end}
    >
      <:col :let={{_id, subscription}} label="Id"><%= subscription.id %></:col>

      <:col :let={{_id, subscription}} label="Type"><%= subscription.type %></:col>

      <:col :let={{_id, subscription}} label="Destination"><%= subscription.destination %></:col>

      <:col :let={{_id, subscription}} label="Event"><%= subscription.event %></:col>

      <:col :let={{_id, subscription}} label="Resource"><%= subscription.resource %></:col>

      <:action :let={{_id, subscription}}>
        <div class="sr-only">
          <.link navigate={~p"/subscriptions/#{subscription}"}>Show</.link>
        </div>

        <.link patch={~p"/subscriptions/#{subscription}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, subscription}}>
        <.link
          phx-click={JS.push("delete", value: %{id: subscription.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="subscription-modal"
      show
      on_cancel={JS.patch(~p"/subscriptions")}
    >
      <.live_component
        module={AshDemoWeb.SubscriptionLive.FormComponent}
        id={(@subscription && @subscription.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        subscription={@subscription}
        patch={~p"/subscriptions"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(
       :subscriptions,
       Ash.read!(AshDemo.Notifications.Subscription, actor: socket.assigns[:current_user])
     )
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Subscription")
    |> assign(
      :subscription,
      Ash.get!(AshDemo.Notifications.Subscription, id, actor: socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Subscription")
    |> assign(:subscription, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Subscriptions")
    |> assign(:subscription, nil)
  end

  @impl true
  def handle_info({AshDemoWeb.SubscriptionLive.FormComponent, {:saved, subscription}}, socket) do
    {:noreply, stream_insert(socket, :subscriptions, subscription)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subscription =
      Ash.get!(AshDemo.Notifications.Subscription, id, actor: socket.assigns.current_user)

    Ash.destroy!(subscription, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :subscriptions, subscription)}
  end
end
