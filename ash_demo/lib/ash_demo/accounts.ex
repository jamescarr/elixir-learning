defmodule AshDemo.Accounts do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource AshDemo.Accounts.Token
    resource AshDemo.Accounts.User
    resource AshDemo.Accounts.Profile
    resource AshDemo.Accounts.Plan
  end
end
