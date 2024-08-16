defmodule PentoWeb.Admin.SurveyActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok,
      socket
      |> assign_survey_activity()
    }
  end

  def assign_survey_activity(socket) do
    assign(socket, :survey_activity, Presence.list_survey_takers())
  end

end
