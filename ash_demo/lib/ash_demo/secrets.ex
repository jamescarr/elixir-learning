defmodule AshDemo.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], AshDemo.Accounts.User, _opts) do
    Application.fetch_env(:ash_demo, :token_signing_secret)
  end
end
