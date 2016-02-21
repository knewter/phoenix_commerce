defmodule PhoenixCommerce.Acceptance.CartTest do
  use ExUnit.Case
  use Hound.Helpers
  hound_session
  alias PhoenixCommerce.{Product, LineItem, Order, Repo, Cart}
  import Ecto.Query, only: [from: 2]

  @upload %Plug.Upload{path: Path.relative_to_cwd("test/files/broom.jpg"), filename: "broom.jpg", content_type: "image/jpg"}

  setup do
    Repo.delete_all(Order)
    Repo.delete_all(Cart)
    Repo.delete_all(LineItem)
    Repo.delete_all(Product)
    {:ok, product} =
      Product.changeset(%Product{}, %{
        name: "Some product",
        description: "Some product description",
        price: Decimal.new("25.20"),
        image: @upload
      }) |> Repo.insert
    {:ok, product: product}
  end

  test "/cart shows empty cart" do
    navigate_to "/cart"
    assert visible_text(heading) == "Your cart"
    assert length(line_items) == 0
  end

  test "adding product to cart shows product in cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button)
    assert length(line_items) == 1
    assert visible_text(hd(line_items)) =~ ~r/#{product.name}/
  end

  test "different sessions have different carts", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button)
    assert length(line_items) == 1
    change_session_to("second user")
    navigate_to "/cart"
    assert length(line_items) == 0
  end

  test "removing an item from the cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button)
    assert length(line_items) == 1
    click(remove_from_cart_button(product))
    assert length(line_items) == 0
  end

  test "updating a line item's quantity", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button)
    update_quantity(product, 5)
    assert quantity(product) == 5
  end

  test "checking out a cart" do
    navigate_to "/cart"
    checkout
    order = get_last_order
    assert order != nil
    assert order.line_items[0].amount == Decimal.new("25.20")
  end

  def heading, do: find_element(:css, "h2")
  def cart, do: find_element(:css, ".cart")
  def cart_table, do: find_within_element(cart, :css, "table")
  def cart_tbody, do: find_within_element(cart_table, :css, "tbody")
  def line_items, do: find_all_within_element(cart_tbody, :css, "tr")
  def add_to_cart_button do
    find_element(:css, "input[type=submit].add-to-cart")
  end
  def remove_from_cart_button(product) do
    product_row(product)
    |> find_within_element(:css, ".remove-from-cart")
  end
  def product_row(product) do
    find_element(:css, "tr.product-#{product.id}")
  end
  def quantity_field(product) do
    product_row(product)
    |> find_within_element(:css, ".quantity")
  end
  def update_quantity(product, qty) do
    quantity_field(product)
    |> fill_field(qty)

    quantity_field(product)
    |> submit_element
  end
  def quantity(product) do
    {qty, _} =
      quantity_field(product)
      |> attribute_value(:value)
      |> Integer.parse

    qty
  end
  def checkout do
    click(checkout_button)
  end
  def checkout_button do
    find_element(:css, "input[type=submit].checkout")
  end
  def get_last_order do
    query =
      from o in Order,
      order_by: [desc: o.inserted_at]

    Repo.one(query)
  end
end
