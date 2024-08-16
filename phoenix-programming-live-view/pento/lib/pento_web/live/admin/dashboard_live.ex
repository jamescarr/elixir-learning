defmodule PentoWeb.Admin.DashboardLive do
  alias PentoWeb.Admin.SurveyResultsLive
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint

  @survey_results_topic "survey_results"
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
    end

    {:ok,
      socket
      |> assign(:survey_results_component_id, "survey_results"
    )}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    IO.puts("rating created recvd")
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )
    {:noreply, socket}
  end
end
