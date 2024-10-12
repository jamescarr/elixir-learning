defmodule MyAshPhoenixApp.Tweets.Tweet do
    use Ash.Resource,
    domain: MyAshPhoenixApp.Tweets.Domain,
    data_layer: Ash.DataLayer.Ets,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id
    attribute :text, :string do
      allow_nil? false
      constraints max_length: 144
      public? true
    end

    attribute :hidden?, :boolean do
      allow_nil? false
      default false
      public? true
    end
  end

  calculations do
    calculate :tweet_length, :integer, expr(string_length(text))
  end

  relationships do
    belongs_to :user, MyAshPhoenixApp.Tweets.User, allow_nil?: false
  end

  actions do
    defaults [:read, update: [:text]]

    create :create do
      primary? true
      accept [:text]
      change relate_actor(:user)
    end
  end

  policies do
    policy action_type(:read) do
      description "If a tweet is hidden, only the author can read it. Otherwise, anyone can."
      authorize_if relates_to_actor_via(:user)
      forbid_if expr(hidden? == true)
      authorize_if always()
    end

    policy action_type(:create) do
      description "Anyone can create a tweet"
      authorize_if always()
    end

    policy action_type(:update) do
      description "Only an admin or the user who tweeted can edit their tweet"
      authorize_if actor_attribute_equals(:admin?, true)
      authorize_if relates_to_actor_via(:user)
    end
  end
end
