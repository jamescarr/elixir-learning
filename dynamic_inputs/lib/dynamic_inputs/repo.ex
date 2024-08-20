defmodule DynamicInputs.Repo do
  use Ecto.Repo,
    otp_app: :dynamic_inputs,
    adapter: Ecto.Adapters.Postgres
end
