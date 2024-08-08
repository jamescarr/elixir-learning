defmodule PentoWeb.ProductLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Catalog
  alias ExAws.S3


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:unit_price]} type="number" label="Unit price" step="any" />
        <.input field={@form[:sku]} type="number" label="Sku" />
        <div phx-drop-target={ @uploads.image.ref }>
          <.label>Image</.label>
          <.live_file_input upload={@uploads.image}/>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
      <%= for image <- @uploads.image.entries do %>
        <div class="mt-4">
          <.live_img_preview entry={image} width="60" />
        </div>
        <progress value={image.progress} max="100" />
        <%= for err <- upload_errors(@uploads.image, image) do %>
          <.error><%= err %></.error>
        <% end %>
        <.button phx-click="cancel-upload" phx-value-ref={image.ref}>Cancel Upload</.button>
      <% end%>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(changeset) end)
     |> allow_upload(:image,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1,
      max_file_size: 9_000_000,
      auto_upload: true
    )}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset = Catalog.change_product(socket.assigns.product, product_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp upload_static_file(%{path: path}, entry) do
    filename = entry.client_name
    case  PentoWeb.S3Helper.upload_image(path, filename) do
      {:ok, _} ->
        {:ok, ~p"/product-images/#{filename}"}
      {:error, response} ->
        {:error, response}
    end
  end

  def params_with_image(socket, params) do
    path =
      socket
      |> consume_uploaded_entries(:image, &upload_static_file/2)
      |> List.first

    Map.put(params, "image_upload", path)
  end

  defp save_product(socket, :edit, params) do
    product_params = params_with_image(socket, params)

    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_product(socket, :new, params) do
    product_params = params_with_image(socket, params)
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end