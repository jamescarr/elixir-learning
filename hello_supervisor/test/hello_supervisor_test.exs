defmodule HelloSupervisorTest do
  use ExUnit.Case
  doctest HelloSupervisor

  test "greets the world" do
    assert HelloSupervisor.hello() == :world
  end
end
