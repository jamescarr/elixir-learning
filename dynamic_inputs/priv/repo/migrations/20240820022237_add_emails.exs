defmodule DynamicInputs.Repo.Migrations.AddEmails do
  use Ecto.Migration

  def change do
    alter table(:mailing_lists) do
      add :emails, :jsonb
    end

  end
end
