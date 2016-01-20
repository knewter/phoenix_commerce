defmodule PhoenixCommerce.CartController do
  use PhoenixCommerce.Web, :controller

  alias PhoenixCommerce.LineItem

  def show(conn, _params) do
    query =
      from li in LineItem,
      preload: [:product]

    line_items = Repo.all(query)

    render conn, "show.html", %{line_items: line_items}
  end

  def add(conn, %{"product" => %{"id" => product_id}}) do
    LineItem.changeset(%LineItem{}, %{
      product_id: product_id,
      quantity: 1
    }) |> Repo.insert!

    redirect conn, to: cart_path(conn, :show)
  end
end
