defmodule DynamicInputsWeb.MailingListLive.Show do
  use DynamicInputsWeb, :live_view

  alias DynamicInputs.Marketing

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:mailing_list, Marketing.get_mailing_list!(id))}
  end

  defp page_title(:show), do: "Show Mailing list"
  defp page_title(:edit), do: "Edit Mailing list"
end
