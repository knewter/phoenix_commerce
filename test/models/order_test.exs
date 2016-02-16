defmodule PhoenixCommerce.OrderTest do
  use PhoenixCommerce.ModelCase

  alias PhoenixCommerce.Order

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end
end
