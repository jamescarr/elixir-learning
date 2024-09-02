defmodule RollDice.Repo do
  use Ecto.Repo,
    otp_app: :roll_dice,
    adapter: Ecto.Adapters.Postgres
end
