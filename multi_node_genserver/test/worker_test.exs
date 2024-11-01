defmodule HelloSupervisorTest do
  alias HelloSupervisor.Worker
  use ExUnit.Case
  doctest Worker

  test "given an element it returns the next one" do
    [first, second | _rest] = Worker.workers

    next = Worker.next(%{worker: first})

    assert next == second
  end

  test "given the last element, it returns the first one" do
    next = Worker.next(%{worker: List.last(Worker.workers)})

    assert next == List.first(Worker.workers)
  end

  test "returns the first element if nil is presented" do
    next = Worker.next(%{worker: nil})

    assert next == List.first(Worker.workers)
  end

end
