defmodule PhoenixCommerce.Product do
  use PhoenixCommerce.Web, :model
  use Arc.Ecto.Model

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :image, PhoenixCommerce.Image.Type
    has_many :line_items, PhoenixCommerce.LineItem

    timestamps
  end

  @required_fields ~w(name description price)
  @optional_fields ~w()

  @required_file_fields ~w()
  @optional_file_fields ~w(image)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end
end
