defmodule PentoWeb.SurveyLive.ComponentTest do
  use PentoWeb.ConnCase
  import Phoenix.Component
  import Phoenix.LiveViewTest

  import PentoWeb.SurveyLive.Component

  test "renders hero section" do
    assigns = %{}

    html = rendered_to_string(
      ~H"""
        <.hero content="Survey">
          A few questions
        </.hero>
      """
    )

    assert html =~ "Survey"
  end

end
