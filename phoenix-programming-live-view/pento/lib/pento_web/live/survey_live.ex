defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.SurveyLive.Component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end
