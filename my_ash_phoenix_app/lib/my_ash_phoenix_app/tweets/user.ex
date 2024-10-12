defmodule MyAshPhoenixApp.Tweets.User do
  use Ash.Resource,
    domain: MyAshPhoenixApp.Tweets.Domain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: [:admin?]]
  end

  attributes do
    uuid_primary_key :id
    attribute :admin?, :boolean do
      allow_nil? false
      default false
    end
  end
end
