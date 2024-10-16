defmodule MessagePublisherTest do
  use ExUnit.Case
  doctest MessagePublisher

  test "greets the world" do
    assert MessagePublisher.publish(%{
      id: UUID.uuid4(),
      process: self()
    }) == :world
  end
end
