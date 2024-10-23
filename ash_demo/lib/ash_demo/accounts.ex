defmodule AshDemo.Accounts do
  use Ash.Domain

  resources do
    resource AshDemo.Accounts.Token
    resource AshDemo.Accounts.User
  end
end
