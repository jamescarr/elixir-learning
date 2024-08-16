defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.Collapsable
  alias Pento.Survey

  alias PentoWeb.SurveyLive.Component
  alias Collapsable
  alias PentoWeb.{RatingLive, SurveyLive, Endpoint}

  @survey_results_topic "survey_results"

  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign_demographic
      |> assign_products
    }
  end

  def assign_products(%{assigns: %{current_user: current_user}}=socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Pento.Catalog.list_products_with_user_ratings(user)
  end

  defp assign_demographic(%{ assigns: %{current_user: current_user}}=socket) do
    assign(socket,
      :demographic,
      Survey.get_demographic_by_user(current_user))
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  def handle_rating_created(
    %{ assigns: %{ products: products }} = socket,
    updated_product,
    product_index) do

    socket
      |> put_flash(:info, "Rating submitted")
      |> assign(
          :products,
          List.replace_at(products, product_index, updated_product)
    )
  end

  def handle_demographic_created(socket, demographic) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{}) # I'm new!
    IO.puts("handle demo created")
    socket
    |> put_flash(:info, "Demographic successfully created!")
    |> assign(:demographic, demographic)
  end
end
