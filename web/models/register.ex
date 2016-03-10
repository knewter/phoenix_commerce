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

  @spec charge(%Cart{}, term()) :: {:ok, map()}
  def charge(cart=%Cart{}, token) do
    amount_in_cents = cart_amount_in_cents(cart)

    params = [
      source: token,
      description: "PhoenixCommerce charge"
    ]

    Stripe.Charges.create amount_in_cents, params
  end

  def cart_amount_in_cents(cart=%Cart{}) do
    amount = cart_amount(cart)
    amount_in_cents_d = Decimal.mult(amount, Decimal.new(100))
    {amount_in_cents, _} = amount_in_cents_d |> Decimal.to_string |> Integer.parse
    amount_in_cents
  end

  def cart_amount(cart=%Cart{}) do
    line_items_query =
      from li in LineItem,
      join: product in assoc(li, :product),
      where: li.cart_id == ^cart.id,
      select: [product.price, li.quantity]

    line_items = Repo.all(line_items_query)

    line_items
    |> Enum.reduce(Decimal.new("0"), fn([price, quantity], acc) ->
      quantity = Decimal.new(quantity)
      Decimal.add(acc, Decimal.mult(price, quantity))
    end)
  end
end
