defmodule AshDemoWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Module.concat(["AshDemo.Accounts"])],
    open_api: "/open_api"
end
