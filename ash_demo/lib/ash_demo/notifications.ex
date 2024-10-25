defmodule AshDemo.Notifications do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource AshDemo.Notifications.Subscription
  end
end
