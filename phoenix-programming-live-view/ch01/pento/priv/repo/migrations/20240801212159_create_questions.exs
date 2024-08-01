defmodule Pento.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :body, :text
      add :votes, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
