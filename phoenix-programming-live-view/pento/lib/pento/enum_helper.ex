defmodule Pento.EnumHelper do
  def display_enum(schema, field, value) do
    Ecto.Enum.mappings(schema, field)
    |> Enum.find_value(fn {k, v} -> if k == value, do: v end)
  end

end

