defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating
  alias Pento.Survey.Demographic
  import PentoWeb.CoreComponents

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_rating()
      |> clear_form()
    }
  end

  def assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def clear_form(%{assigns: %{rating: rating}} = socket) do
    assign_form(socket, Survey.change_rating(rating))
  end


  def assign_rating(%{assigns: %{current_user: current_user, product: product}} =
    socket) do
    assign(socket, :rating,
      %Rating{
        user_id: current_user.id,
        product_id: product.id})
  end

  def handle_event("validate", %{"rating" => rating_params}, socket) do
    changeset =
      socket.assigns.rating
      |> Survey.change_rating(rating_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  def save_rating(%{assigns: %{product_index: product_index, product: product}} = socket, rating_params) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end


  end

end
