defmodule AshDemoWeb.SubscriptionLive.Show do
  use AshDemoWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Subscription <%= @subscription.id %>
      <:subtitle>This is a subscription record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/subscriptions/#{@subscription}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit subscription</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @subscription.id %></:item>

      <:item title="Type"><%= @subscription.type %></:item>

      <:item title="Destination"><%= @subscription.destination %></:item>

      <:item title="Event"><%= @subscription.event %></:item>

      <:item title="Resource"><%= @subscription.resource %></:item>
    </.list>

    <.back navigate={~p"/subscriptions"}>Back to subscriptions</.back>

    <.modal
      :if={@live_action == :edit}
      id="subscription-modal"
      show
      on_cancel={JS.patch(~p"/subscriptions/#{@subscription}")}
    >
      <.live_component
        module={AshDemoWeb.SubscriptionLive.FormComponent}
        id={@subscription.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        subscription={@subscription}
        patch={~p"/subscriptions/#{@subscription}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :subscription,
       Ash.get!(AshDemo.Notifications.Subscription, id, actor: socket.assigns.current_user)
     )}
  end

  defp page_title(:show), do: "Show Subscription"
  defp page_title(:edit), do: "Edit Subscription"
end
