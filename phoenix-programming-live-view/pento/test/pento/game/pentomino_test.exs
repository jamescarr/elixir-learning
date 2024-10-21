defmodule Pento.Game.PentominoTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Pento.Game.{Pentomino, Board, Shape}

  describe "shape reducers" do

    test "it should create expected shape points" do
      p = Pentomino.new(name: :p)
        |> assert_shape(:p, [{8, 7}, {9, 8}, {8, 8}, {9, 7}, {8, 9}])
        |> Pentomino.rotate
        |> assert_shape(:p, [{7, 8}, {8, 7}, {8, 8}, {7, 7}, {9, 8}])
        |> Pentomino.rotate
        |> assert_shape(:p, [{8, 9}, {7, 8}, {8, 8}, {7, 9}, {8, 7}])

    end

  end

  defp assert_shape(%Pentomino{} = p, expected_name, expected_points)
    when is_atom(expected_name) and is_list(expected_points) do
    shape = Pentomino.to_shape(p)

    assert shape.name == expected_name
    assert shape.points == expected_points

    p
  end

  defp assert_shape(invalid_shape, _name, _points) do
    flunk("Expected a Shape struct, got #{inspect(invalid_shape)}")
  end


end
