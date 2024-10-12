defmodule MyAshPhoenixApp.Tweets.Domain do
  use Ash.Domain,
    validate_config_inclusion?: false

  resources do
    resource MyAshPhoenixApp.Tweets.Tweet do
      define :create_tweet, action: :create, args: [:text]
      define :update_tweet, action: :update, args: [:text]
      define :list_tweets, action: :read
    end

    resource MyAshPhoenixApp.Tweets.User do
      define :create_user, action: :create
    end
  end
end
