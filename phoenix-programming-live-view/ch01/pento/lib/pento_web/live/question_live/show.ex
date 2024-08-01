defmodule PentoWeb.QuestionLive.Show do
  use PentoWeb, :live_view

  alias Pento.FAQ

  @impl true
  def mount(params, _session, socket) do
    {:ok,
      stream(socket, :answers, FAQ.answers_for_question(params["id"]))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:question, FAQ.get_question!(id))}
  end

  defp page_title(:show), do: "Show Question"
  defp page_title(:edit), do: "Edit Question"
end
