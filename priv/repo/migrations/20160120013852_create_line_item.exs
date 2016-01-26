defmodule PhoenixCommerce.Repo.Migrations.CreateLineItem do
  use Ecto.Migration

  def change do
    create table(:line_items) do
      add :product_id, references(:products)
      add :quantity, :integer

      timestamps
    end

  end
end
