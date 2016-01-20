defmodule PhoenixCommerce.Acceptance.CartTest do
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

  test "/cart shows empty cart" do
    navigate_to "/cart"
    heading = find_element(:css, "h2")
    cart = find_element(:css, ".cart")
    cart_table = find_within_element(cart, :css, "table")
    cart_tbody = find_within_element(cart_table, :css, "tbody")
    line_items = find_all_within_element(cart_tbody, :css, "tr")
    assert visible_text(heading) == "Your cart"
    assert length(line_items) == 0
  end
end
