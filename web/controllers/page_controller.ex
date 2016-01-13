defmodule PhoenixCommerce.PageController do
  use PhoenixCommerce.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
