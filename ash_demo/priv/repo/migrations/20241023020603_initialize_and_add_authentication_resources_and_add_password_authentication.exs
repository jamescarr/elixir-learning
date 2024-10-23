defmodule AshDemo.Repo.Migrations.InitializeAndAddAuthenticationResourcesAndAddPasswordAuthentication do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :confirmed_at, :utc_datetime_usec
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :text, null: false
    end

    create unique_index(:users, [:email], name: "users_unique_email_index")

    create table(:tokens, primary_key: false) do
      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :jti, :text, null: false, primary_key: true
      add :subject, :text, null: false
      add :expires_at, :utc_datetime, null: false
      add :purpose, :text, null: false
      add :extra_data, :map

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end
  end

  def down do
    drop table(:tokens)

    drop_if_exists unique_index(:users, [:email], name: "users_unique_email_index")

    drop table(:users)
  end
end