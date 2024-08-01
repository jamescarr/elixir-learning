# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pento.Catalog



Enum.each 1..1_000_000, fn n ->
  product = %{
    name: "Product ##{n}",
    description: "Lorem Ipsum #{n}",
    sku: Enum.random(1_000_000..5_000_000),
    unit_price: :rand.uniform() * 100
  }
  Catalog.create_product(product)
end
