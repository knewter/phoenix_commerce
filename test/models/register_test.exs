defmodule PhoenixCommerce.RegisterTest do
  use ExUnit.Case
  alias PhoenixCommerce.{Product, LineItem, Cart, Register, Order, Repo}

  setup do
    Repo.delete_all(LineItem)
    Repo.delete_all(Product)
    Repo.delete_all(Cart)
    {:ok, product} =
      Product.changeset(%Product{}, %{
        name: "Some product",
        description: "Some product description",
        price: Decimal.new("25.20")
      }) |> Repo.insert

    {:ok, cart} =
      Cart.changeset(%Cart{}, %{})
      |> Repo.insert

    {:ok, _line_item} =
      LineItem.changeset(%LineItem{}, %{
        product_id: product.id,
        cart_id: cart.id,
        quantity: 1
      }) |> Repo.insert

    {:ok, cart: cart}
  end

  test "ordering a cart introduces a new order with the cart's line items", %{cart: cart} do
    assert {:ok, order=%Order{}} = Register.order(cart)
    assert 1 = length(order.line_items)
  end
end
