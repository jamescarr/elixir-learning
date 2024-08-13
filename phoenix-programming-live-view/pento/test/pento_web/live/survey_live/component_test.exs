defmodule PentoWeb.SurveyLive.ComponentTest do
  use PentoWeb.ConnCase
  import Phoenix.Component
  import Phoenix.LiveViewTest

  import PentoWeb.SurveyLive.Component
  import PentoWeb.SurveyLive.ListComponent

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

  test "component that builds an html title with configurable message" do
    assigns = %{}

    html = rendered_to_string(~H"""
      <.title content="Lorem Ipsum">Foobar</.title>
      """)

    assert html =~ "Foobar"
    assert html =~ "Lorem Ipsum"
  end

  test "render a list item" do
    assigns = %{}

    html = rendered_to_string(~H"""
      <.item>foo</.item>
    """)

    assert html =~ "<li>foo</li>"

  end

  test "render a whole html list" do
    assigns = %{
      questions: ["one?", "two?"]
    }

    html = rendered_to_string(~H"""
      <.survey questions={@questions}/>
    """)

    assert html =~ "<li>one?</li>"
    assert html =~ "<li>two?</li>"
  end



end
