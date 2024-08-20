defmodule DynamicInputs.EngineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DynamicInputs.Engine` context.
  """

  @doc """
  Generate a webhook.
  """
  def webhook_fixture(attrs \\ %{}) do
    {:ok, webhook} =
      attrs
      |> Enum.into(%{
        content_type: "some content_type",
        headers: %{},
        name: "some name",
        payload: "some payload",
        url: "some url"
      })
      |> DynamicInputs.Engine.create_webhook()

    webhook
  end
end
