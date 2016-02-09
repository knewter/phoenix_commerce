defmodule PhoenixCommerce.LineItemController do
  use PhoenixCommerce.Web, :controller

  alias PhoenixCommerce.LineItem

  def delete(conn, %{"id" => id}) do
    line_item = Repo.get!(LineItem, id)

    Repo.delete!(line_item)

    conn
    |> put_flash(:info, "Line Item removed from cart successfully.")
    |> redirect(to: cart_path(conn, :show))
  end

  def update(conn, %{"id" => id, "line_item" => line_item_params}) do
    line_item = Repo.get!(LineItem, id)
    changeset = LineItem.changeset(line_item, line_item_params)

    case Repo.update(changeset) do
      {:ok, line_item} ->
        conn
        |> put_flash(:info, "Line Item updated successfully.")
        |> redirect(to: cart_path(conn, :show))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "There was a problem updating the line item.")
        |> redirect(to: cart_path(conn, :show))
    end
  end
end
