defmodule PhoenixCommerce.Register do
  alias PhoenixCommerce.{Cart, LineItem, Order, Repo}
  import Ecto.Query

  @spec order(%Cart{}) :: {:ok, %Order{}}
  def order(cart=%Cart{}) do
    Repo.transaction(fn() ->
      order =
        Order.changeset(%Order{}, %{})
        |> Repo.insert!

      line_items =
        from li in LineItem,
        where: li.cart_id == ^cart.id

      {_count, _returnval} =
        line_items
        |> Repo.update_all(set: [cart_id: nil, order_id: order.id])

      order = Repo.preload(order, :line_items)

      order
    end)
  end
end
