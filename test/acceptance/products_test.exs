defmodule PhoenixCommerce.Acceptance.ProductsTest do
  use ExUnit.Case
  use Hound.Helpers
  hound_session
  alias PhoenixCommerce.Product
  alias PhoenixCommerce.Repo

  test "/products has a list of products" do
    navigate_to "/products"
    assert find_element(:css, "ul.products")
  end

  test "/products - product details include name, description, and price" do
    {:ok, product} =
      %Product{
        name: "Some product",
        description: "Some product description",
        price: Decimal.new("25.20")
      } |> Repo.insert

    navigate_to "/products"
    product_li = find_element(:css, "ul.products li")
    name = find_within_element(product_li, :css, "h3")
    price = find_within_element(product_li, :css, "h4")
    description = find_within_element(product_li, :css, "p")
    assert visible_text(name) == product.name
    assert visible_text(price) == "$#{product.price}"
    assert visible_text(description) == product.description
  end
end
