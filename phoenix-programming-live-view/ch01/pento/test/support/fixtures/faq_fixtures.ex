defmodule Pento.FAQFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.FAQ` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title",
        votes: 42
      })
      |> Pento.FAQ.create_question()

    question
  end
end
