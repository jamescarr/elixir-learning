defmodule AshDemo.Repo.Migrations.BlogMigration do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:profiles, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :bio, :text
      add :profile_picture, :text
      add :public_profile, :boolean, null: false

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "profiles_user_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create table(:posts, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :title, :text, null: false
      add :content, :text
    end
  end

  def down do
    drop table(:posts)

    drop constraint(:profiles, "profiles_user_id_fkey")

    drop table(:profiles)
  end
end
