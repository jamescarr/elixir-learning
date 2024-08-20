defmodule DynamicInputsWeb.MailingListLive.Index do
  use DynamicInputsWeb, :live_view

  alias DynamicInputs.Marketing
  alias DynamicInputs.Marketing.MailingList

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :mailing_lists, Marketing.list_mailing_lists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Mailing list")
    |> assign(:mailing_list, Marketing.get_mailing_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Mailing list")
    |> assign(:mailing_list, %MailingList{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Mailing lists")
    |> assign(:mailing_list, nil)
  end

  @impl true
  def handle_info({DynamicInputsWeb.MailingListLive.FormComponent, {:saved, mailing_list}}, socket) do
    {:noreply, stream_insert(socket, :mailing_lists, mailing_list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    mailing_list = Marketing.get_mailing_list!(id)
    {:ok, _} = Marketing.delete_mailing_list(mailing_list)

    {:noreply, stream_delete(socket, :mailing_lists, mailing_list)}
  end
end
