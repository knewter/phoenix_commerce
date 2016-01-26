defmodule PhoenixCommerce.LineItemTest do
  use PhoenixCommerce.ModelCase

  alias PhoenixCommerce.{LineItem, Repo, Cart, Product}

  @product Repo.insert!(%Product{name: "Some product", description: "Some product", price: Decimal.new("22.50")})
  @cart Repo.insert!(%Cart{})
  @valid_attrs %{product_id: @product.id, quantity: 42, cart_id: @cart.id}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LineItem.changeset(%LineItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LineItem.changeset(%LineItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
