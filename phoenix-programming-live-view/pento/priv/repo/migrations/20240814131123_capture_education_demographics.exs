defmodule Pento.Repo.Migrations.CaptureEducationDemographics do
  use Ecto.Migration

  def change do
    alter table(:demographics) do
      add :education, :string
    end
  end
end
