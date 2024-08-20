defmodule DynamicInputsWeb.MailingListLive.FormComponent do
  use DynamicInputsWeb, :live_component

  alias DynamicInputs.Marketing

  @impl true
  def render(assigns) do
    ~H"""
      <div class="max-w-2xl mx-auto">
        <.header>
          <%= @title %>
          <:subtitle>Manage mailing list records</:subtitle>
        </.header>

        <.simple_form
          for={@form}
          id="mailing_list-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          class="space-y-4"
        >
          <.input field={@form[:title]} type="text" label="Title" />

          <div class="space-y-2">
            <label class="block text-sm font-medium text-gray-700">Email List</label>
            <.inputs_for :let={ef} field={@form[:emails]}>
              <div class="flex items-center space-x-2">
                <input type="hidden" name="mailing_list[emails_sort][]" value={ef.index} />
                <div class="flex-grow flex space-x-2">
                  <.input type="email" field={ef[:email]} placeholder="Email" class="flex-1 py-1 text-sm" />
                  <.input type="text" field={ef[:name]} placeholder="Name" class="flex-1 py-1 text-sm" />
                </div>
                <button
                  type="button"
                  name="mailing_list[emails_drop][]"
                  value={ef.index}
                  phx-click={JS.dispatch("change")}
                  class="text-red-600 hover:text-red-800"
                >
                  <.icon name="hero-x-mark" class="w-4 h-4" />
                </button>
              </div>
            </.inputs_for>
          </div>

          <input type="hidden" name="mailing_list[emails_drop][]" />

          <button
            type="button"
            name="mailing_list[emails_sort][]"
            value="new"
            phx-click={JS.dispatch("change")}
            class="text-sm text-blue-600 hover:text-blue-800"
          >
            + Add email
          </button>

          <:actions>
            <.button phx-disable-with="Saving..." class="w-full">Save Mailing List</.button>
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
