defmodule Pento.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :username, :string
      unique_index "users", :username
    end
  end

  def down do
    alter table("users") do
      remove :username
    end
  end

end
