defmodule DynamicInputs.Engine.Webhook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "webhooks" do
    field :name, :string
    field :url, :string
    field :headers, :map
    field :payload, :string
    field :content_type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, [:name, :url, :content_type, :headers, :payload])
    |> validate_required([:name, :url, :content_type, :payload])
  end
end
