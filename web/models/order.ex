defmodule PhoenixCommerce.Order do
  use PhoenixCommerce.Web, :model

  schema "orders" do
    has_many :line_items, PhoenixCommerce.LineItem

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
