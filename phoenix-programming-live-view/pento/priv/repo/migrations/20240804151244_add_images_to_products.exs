defmodule Pento.Repo.Migrations.AddImagesToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :image_upload, :string
    end

  end
end
