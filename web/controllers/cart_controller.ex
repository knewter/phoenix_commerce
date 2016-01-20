defmodule PhoenixCommerce.CartController do
  use PhoenixCommerce.Web, :controller

  def show(conn, _params) do
    render conn, "show.html"
  end
end
