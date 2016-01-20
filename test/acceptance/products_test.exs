defmodule PhoenixCommerce.Acceptance.ProductsTest do
  use ExUnit.Case
  use Hound.Helpers
  hound_session
  alias PhoenixCommerce.Product
  alias PhoenixCommerce.Repo

  @upload %Plug.Upload{path: Path.relative_to_cwd("test/files/broom.jpg"), filename: "broom.jpg", content_type: "image/jpg"}

  setup do
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

  test "/products has a list of products" do
    navigate_to "/products"
    assert find_element(:css, "ul.products")
  end

  test "/products - product details include name, description, image, and price", %{product: product} do
    navigate_to "/products"
    product_li = find_element(:css, "ul.products li")
    name = find_within_element(product_li, :css, "h3")
    price = find_within_element(product_li, :css, "h4")
    description = find_within_element(product_li, :css, "p")
    image = find_within_element(product_li, :css, "img")
    assert visible_text(name) == product.name
    assert visible_text(price) == "$#{product.price}"
    assert visible_text(description) == product.description
    assert attribute_value(image, "src") =~ ~r/amazon/
  end

  test "/products - click a product to view its details", %{product: product} do
    navigate_to "/products"
    product_li = find_element(:css, "ul.products li")
    link = find_within_element(product_li, :css, "a")
    click(link)
    assert "/products/#{product.id}" == current_path
  end
end
