defmodule AshDemoWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [],
    open_api: "/open_api"
end