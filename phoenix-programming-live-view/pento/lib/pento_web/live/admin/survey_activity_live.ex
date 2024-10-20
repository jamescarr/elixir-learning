defmodule PentoWeb.Admin.SurveyActivityLive do
  use PentoWeb, :live_component
  require Logger

  def update(%{survey_activity: survey_activity}, socket) do
    Logger.info("Updating activity")
    IO.inspect(survey_activity)
    {:ok,
      socket
      |> assign(:survey_activity, survey_activity)
    }
  end

  def update(params, socket) do
    Logger.info("non-match update, #{inspect(params)}")
    {:ok,
      socket
      |> assign(:survey_activity, [[]])
    }
  end


end
