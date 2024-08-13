defmodule PentoWeb.SurveyLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> clear_form()
    }
  end

  defp assign_demographic(
    %{assigns: %{current_user: current_user}} = socket
  ) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{demographic: demographic}} = socket) do
    assign_form(socket, Survey.change_demographic(demographic))

  end

  def params_with_user_id(params, %{assigns: %{current_user: current_user}}) do
    params
    |> Map.put("user_id", current_user.id)
  end

  defp save_demographic(socket, params) do
    case Survey.create_demographic(params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end

  end

  def handle_event("save", %{"demographic" => demo}, socket) do
    IO.puts("Handling 'save' event and demographic record!")
    params = params_with_user_id(demo, socket)
    IO.inspect(params)
    {:noreply, save_demographic(socket, params)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end


end
