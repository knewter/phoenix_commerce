defmodule PhoenixCommerce.CartTest do
  use PhoenixCommerce.ModelCase

  alias PhoenixCommerce.Cart

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cart.changeset(%Cart{}, @valid_attrs)
    assert changeset.valid?
  end
end
