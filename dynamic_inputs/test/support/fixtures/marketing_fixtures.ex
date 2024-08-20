defmodule DynamicInputs.MarketingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DynamicInputs.Marketing` context.
  """

  @doc """
  Generate a mailing_list.
  """
  def mailing_list_fixture(attrs \\ %{}) do
    {:ok, mailing_list} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> DynamicInputs.Marketing.create_mailing_list()

    mailing_list
  end
end
