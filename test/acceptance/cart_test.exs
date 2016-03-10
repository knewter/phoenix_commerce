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

  test "checking out a cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button)
    navigate_to "/cart"
    checkout
    order = get_last_order
    assert order != nil
    assert hd(order.line_items).quantity == 1
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
    :timer.sleep(1000) # Give the modal time to appear
    focus_frame("stripe_checkout_app")
    fill_email("josh.rubyist@gmail.com")
    fill_card_number("4111")
    fill_card_number("1111")
    fill_card_number("1111")
    fill_card_number("1111")
    fill_date("11")
    fill_date("17")
    fill_cvc("111")
    submit_checkout
    focus_parent_frame
    :timer.sleep(6_000) # Give the controller time to order the cart
  end
  def fill_email(val) do
    find_element(:css, "#email")
    |> fill_field(val)
  end
  def fill_card_number(val) do
    find_element(:css, "#card_number")
    |> input_into_field(val)
  end
  def fill_date(val) do
    find_element(:css, "#cc-exp")
    |> input_into_field(val)
  end
  def fill_cvc(val) do
    find_element(:css, "#cc-csc")
    |> fill_field(val)
  end
  def submit_checkout do
    find_element(:css, "#submitButton")
    |> click
  end
  def checkout_button do
    find_element(:css, "button.stripe-button-el")
  end
  def get_last_order do
    query =
      from o in Order,
      order_by: [desc: o.inserted_at],
      preload: [:line_items]

    Repo.one(query)
  end
end
