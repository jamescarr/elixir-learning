defmodule AshDemo.Accounts.Profile do
  use Ash.Resource,
    otp_app: :ash_demo,
    domain: AshDemo.Accounts,
    extensions: [AshJsonApi.Resource],
    data_layer: AshPostgres.DataLayer

  json_api do
    type "profile"
  end

  postgres do
    table "profiles"
    repo AshDemo.Repo
  end

  actions do
    defaults [:read]
  end

  attributes do
    uuid_primary_key :id

    attribute :bio, :string do
      public? true
    end

    attribute :profile_picture, :string do
      public? true
    end

    attribute :public_profile, :boolean do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :user, AshDemo.Accounts.User
  end
end
