defmodule DynamicInputsWeb.MailingListLive.FormComponent do
  use DynamicInputsWeb, :live_component

  alias DynamicInputs.Marketing

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage mailing_list records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="mailing_list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Mailing list</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{mailing_list: mailing_list} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Marketing.change_mailing_list(mailing_list))
     end)}
  end

  @impl true
  def handle_event("validate", %{"mailing_list" => mailing_list_params}, socket) do
    changeset = Marketing.change_mailing_list(socket.assigns.mailing_list, mailing_list_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"mailing_list" => mailing_list_params}, socket) do
    save_mailing_list(socket, socket.assigns.action, mailing_list_params)
  end

  defp save_mailing_list(socket, :edit, mailing_list_params) do
    case Marketing.update_mailing_list(socket.assigns.mailing_list, mailing_list_params) do
      {:ok, mailing_list} ->
        notify_parent({:saved, mailing_list})

        {:noreply,
         socket
         |> put_flash(:info, "Mailing list updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_mailing_list(socket, :new, mailing_list_params) do
    case Marketing.create_mailing_list(mailing_list_params) do
      {:ok, mailing_list} ->
        notify_parent({:saved, mailing_list})

        {:noreply,
         socket
         |> put_flash(:info, "Mailing list created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
