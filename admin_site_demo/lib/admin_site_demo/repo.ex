defmodule AdminSiteDemo.Repo do
  use Ecto.Repo,
    otp_app: :admin_site_demo,
    adapter: Ecto.Adapters.Postgres
end
