defmodule AshDemo.Blog do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource AshDemo.Blog.Post do
      define :create_post, action: :create
      define :list_posts, action: :read
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end
  end

  json_api do
    routes do
      base_route "/posts", AshDemo.Blog.Post do
        get :read
        index :read
        post :create
      end
    end


  end

end
