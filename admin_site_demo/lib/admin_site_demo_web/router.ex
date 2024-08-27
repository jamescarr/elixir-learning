defmodule AdminSiteDemoWeb.Router do
  use AdminSiteDemoWeb, :router
  import Backpex.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AdminSiteDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Backpex.ThemeSelectorPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AdminSiteDemoWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/admin", AdminSiteDemoWeb do
    pipe_through :browser

    backpex_routes()

    live_session :default, on_mount: Backpex.InitAssigns do
      live_resources "/posts", PostLive
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", AdminSiteDemoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:admin_site_demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AdminSiteDemoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
