defmodule DynamicInputs.Repo.Migrations.CreateMailingLists do
  use Ecto.Migration

  def change do
    create table(:mailing_lists) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end
  end
end
