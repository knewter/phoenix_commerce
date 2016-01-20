# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixCommerce.Repo.insert!(%PhoenixCommerce.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias PhoenixCommerce.Product
alias PhoenixCommerce.Repo

upload = %Plug.Upload{path: Path.relative_to_cwd("test/files/broom.jpg"), filename: "broom.jpg", content_type: "image/jpg"}
{:ok, _product} =
  Product.changeset(%Product{}, %{
    name: "Some product",
    description: "Some product description",
    price: Decimal.new("25.20"),
    image: upload
  }) |> Repo.insert
