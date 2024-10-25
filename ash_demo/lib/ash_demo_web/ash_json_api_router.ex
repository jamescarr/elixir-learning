defmodule AshDemoWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [
      Module.concat(["AshDemo.Accounts"]),
      Module.concat(["AshDemo.Blog"]),
      Module.concat(["AshDemo.Notifications"])
    ],
    open_api: "/open_api"
end
