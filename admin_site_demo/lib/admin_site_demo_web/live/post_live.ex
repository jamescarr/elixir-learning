defmodule AdminSiteDemoWeb.Live.PostLive do
  use Backpex.LiveResource,
    layout: {AdminSiteDemoWeb.Layouts, :admin},
    schema: AdminSiteDemo.Blog.Post,
    repo: AdminSiteDemo.Repo,
    update_changeset: &AdminSiteDemo.Blog.Post.changeset/3,
    create_changeset: &AdminSiteDemo.Blog.Post.changeset/3,
    pubsub: AdminSiteDemo.PubSub,
    topic: "posts",
    event_prefix: "post_"

  @impl Backpex.LiveResource
  def singular_name, do: "Post"

  @impl Backpex.LiveResource
  def plural_name, do: "Posts"

  @impl Backpex.LiveResource
  def fields do
    [
      title: %{
        module: Backpex.Fields.Text,
        label: "Title"
      },
      views: %{
        module: Backpex.Fields.Number,
        label: "Views"
      }
    ]
  end
end
