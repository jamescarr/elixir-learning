defmodule DynamicInputs.Repo.Migrations.CreateWebhooks do
  use Ecto.Migration

  def change do
    create table(:webhooks) do
      add :name, :string
      add :url, :string
      add :content_type, :string
      add :headers, :map
      add :payload, :text

      timestamps(type: :utc_datetime)
    end
  end
end
