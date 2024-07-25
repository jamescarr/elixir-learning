defmodule TaskProcessorTest do
  use ExUnit.Case
  doctest TaskProcessor

  test "greets the world" do
    assert TaskProcessor.hello() == :world
  end
end
