defmodule AshDemo.Notifications.Subscription do
  use Ash.Resource,
    otp_app: :ash_demo,
    domain: AshDemo.Notifications,
    extensions: [AshJsonApi.Resource],
    data_layer: AshPostgres.DataLayer

  json_api do
    type "subscription"
  end

  postgres do
    table "subscriptions"
    repo AshDemo.Repo
  end

  actions do
    defaults [
      :read,
      :destroy,
      create: [:type, :destination, :event, :resource],
      update: [:type, :destination, :event, :resource]
    ]
  end

  attributes do
    uuid_primary_key :id

    attribute :type, :string do
      allow_nil? false
      public? true
    end

    attribute :destination, :string do
      allow_nil? false
      public? true
    end

    attribute :event, :string do
      allow_nil? false
      public? true
    end

    attribute :resource, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :user, AshDemo.Accounts.User
  end
end
