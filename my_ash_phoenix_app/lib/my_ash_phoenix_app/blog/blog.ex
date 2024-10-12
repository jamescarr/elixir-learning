defmodule MyAshPhoenixApp.Blog do
  use Ash.Domain,
    extensions: [
      AshGraphql.Domain
    ]

  resources do
    resource MyAshPhoenixApp.Blog.Post do
      # Define an interface for calling these actions
      define :create_post, action: :create
      define :list_posts, action: :read
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end

  end

end
